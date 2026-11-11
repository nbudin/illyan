require 'test_helper'

# Exercises the CAS protocol endpoints (/cas/login, /cas/serviceValidate,
# /cas/proxyValidate, /cas/logout) against the real production authenticator
# configuration, since this is the app's core job.
class CasFlowTest < ActionDispatch::IntegrationTest
  SERVICE_URL = "https://client.example.com/app".freeze

  setup do
    # The default test config uses Cassy's stub authenticator; use the real one.
    Cassy.config_file = Rails.root.join("config", "cassy.yml")

    @service = FactoryBot.create(:service, urls: [SERVICE_URL])
    @person = FactoryBot.create(:joe_user)
  end

  teardown do
    Warden.test_reset!
  end

  def login_and_get_ticket
    login_as @person, scope: :person
    get "/cas/login", params: { service: SERVICE_URL }
    assert_response :redirect
    location = response.location
    assert location.start_with?("#{SERVICE_URL}?ticket=ST-"), "unexpected redirect: #{location}"
    location[/ticket=(ST-[^&]+)/, 1]
  end

  describe "login" do
    it "refuses unknown services" do
      get "/cas/login", params: { service: "https://evil.example.com/" }
      assert_response :forbidden
    end

    it "sends anonymous users to the Devise login page" do
      get "/cas/login", params: { service: SERVICE_URL }
      assert_redirected_to new_person_session_path
    end

    it "redirects signed-in users back to the service with a service ticket" do
      ticket = login_and_get_ticket
      assert Cassy::ServiceTicket.find_by(ticket: ticket)
    end

    it "sets the tgt cookie" do
      login_and_get_ticket
      assert cookies["tgt"].present?
    end

    it "allows other paths on a registered service's origin" do
      login_as @person, scope: :person
      get "/cas/login", params: { service: "https://client.example.com/other/page" }
      assert_response :redirect
      assert response.location.start_with?("https://client.example.com/other/page?ticket=ST-")
    end

    it "treats the service host case-insensitively" do
      login_as @person, scope: :person
      get "/cas/login", params: { service: "https://CLIENT.EXAMPLE.COM/x" }
      assert_response :redirect
      assert response.location.start_with?("https://CLIENT.EXAMPLE.COM/x?ticket=ST-")
    end

    describe "with look-alike service URLs" do
      setup do
        # Registered hosts with a hyphen exercise prefix matching
        @service.update!(urls: [SERVICE_URL, "https://my-app.example.com/"])
        login_as @person, scope: :person
      end

      [
        ["userinfo naming a registered host", "https://client.example.com@evil.example.org/x"],
        ["userinfo with a password", "https://client.example.com:pw@evil.example.org/x"],
        ["a different host sharing a hyphenated prefix", "https://my-evil.example.org/x"],
        ["a registered host as a subdomain of another", "https://client.example.com.evil.example.org/x"],
        ["a different scheme", "http://client.example.com/x"],
        ["a different port", "https://client.example.com:8443/x"],
        ["a protocol-relative URL", "//evil.example.org/x"],
        ["a non-http scheme", "javascript://client.example.com/%0aalert(1)"]
      ].each do |label, service|
        it "refuses #{label} and issues no ticket" do
          assert_no_difference -> { Cassy::ServiceTicket.count } do
            get "/cas/login", params: { service: service }
          end
          assert_response :forbidden
          assert_nil response.location
        end
      end
    end

    describe "in gateway mode" do
      it "sends anonymous users back to the service without a ticket" do
        get "/cas/login", params: { service: SERVICE_URL, gateway: "true" }
        assert_response :redirect
        assert_equal SERVICE_URL, response.location
        assert_equal 0, Cassy::ServiceTicket.count
      end

      it "accepts gateway=1" do
        get "/cas/login", params: { service: SERVICE_URL, gateway: "1" }
        assert_equal SERVICE_URL, response.location
      end

      it "sends anonymous users back to another path on a registered origin" do
        get "/cas/login", params: { service: "https://client.example.com/elsewhere", gateway: "true" }
        assert_equal "https://client.example.com/elsewhere", response.location
      end

      it "still refuses unregistered and look-alike services" do
        ["https://evil.example.org/", "https://client.example.com@evil.example.org/x"].each do |service|
          get "/cas/login", params: { service: service, gateway: "true" }
          assert_response :forbidden, "service=#{service}"
          assert_nil response.location, "service=#{service}"
        end
      end

      it "still issues a ticket to a signed-in user" do
        login_as @person, scope: :person
        get "/cas/login", params: { service: SERVICE_URL, gateway: "true" }
        assert response.location.start_with?("#{SERVICE_URL}?ticket=ST-"), "unexpected redirect: #{response.location}"
      end
    end

    it "completes the full anonymous flow: Devise login, then back to the service with a ticket" do
      get "/cas/login", params: { service: SERVICE_URL }
      assert_redirected_to new_person_session_path

      post person_session_path, params: { person: { email: "joe@user.com", password: "password" } }
      assert_response :redirect
      follow_redirect!

      assert_response :redirect
      assert response.location.start_with?("#{SERVICE_URL}?ticket=ST-"), "unexpected redirect: #{response.location}"
      assert_includes @person.reload.services, @service
    end
  end

  describe "serviceValidate" do
    it "validates a good ticket and returns the user and attributes as CAS XML" do
      ticket = login_and_get_ticket

      get "/cas/serviceValidate", params: { service: SERVICE_URL, ticket: ticket }

      assert_response :success
      xml = Nokogiri::XML(response.body)
      xml.remove_namespaces!
      assert_equal "joe@user.com", xml.at_xpath("//authenticationSuccess/user").text
      assert_equal "joe@user.com", xml.at_xpath("//authenticationSuccess/email")&.text
    end

    it "rejects a ticket that has already been used" do
      ticket = login_and_get_ticket
      get "/cas/serviceValidate", params: { service: SERVICE_URL, ticket: ticket }
      assert_response :success

      get "/cas/serviceValidate", params: { service: SERVICE_URL, ticket: ticket }
      assert_response 422
      assert_match(/authenticationFailure/, response.body)
    end

    it "rejects an unknown ticket" do
      get "/cas/serviceValidate", params: { service: SERVICE_URL, ticket: "ST-bogus" }
      assert_response 422
      assert_match(/authenticationFailure/, response.body)
    end

    it "rejects a ticket presented for a look-alike of the service it was issued for" do
      ticket = login_and_get_ticket
      [
        "https://client.example.com@evil.example.org/x",
        "http://client.example.com/app"
      ].each do |lookalike|
        get "/cas/serviceValidate", params: { service: lookalike, ticket: ticket }
        assert_response 422, "service=#{lookalike}"
      end
    end

    it "accepts the ticket for another path on the same origin" do
      ticket = login_and_get_ticket
      get "/cas/serviceValidate", params: { service: "https://client.example.com/elsewhere", ticket: ticket }
      assert_response :success
    end

    it "rejects a ticket presented for a different service" do
      ticket = login_and_get_ticket
      get "/cas/serviceValidate", params: { service: "https://other.example.com", ticket: ticket }
      assert_response 422
    end
  end

  describe "proxyValidate" do
    it "validates a good ticket" do
      ticket = login_and_get_ticket
      get "/cas/proxyValidate", params: { service: SERVICE_URL, ticket: ticket }
      assert_response :success
      assert_match(/authenticationSuccess/, response.body)
    end

    it "rejects an unknown ticket" do
      get "/cas/proxyValidate", params: { service: SERVICE_URL, ticket: "ST-bogus" }
      assert_response 422
    end
  end

  describe "logout" do
    it "destroys the ticket-granting ticket and redirects to the login page" do
      login_and_get_ticket
      assert_difference -> { Cassy::TicketGrantingTicket.count }, -1 do
        get "/cas/logout", params: { service: SERVICE_URL }
      end
      assert_response :redirect
    end

    it "sends gateway logouts back to an absolute service URL" do
      get "/cas/logout", params: { service: SERVICE_URL, gateway: "true" }
      assert_response 303
      assert_equal SERVICE_URL, response.location
    end

    it "sends gateway logouts to other paths on a registered service's origin" do
      get "/cas/logout", params: { service: "https://client.example.com/signed-out", gateway: "true" }
      assert_response 303
      assert_equal "https://client.example.com/signed-out", response.location
    end

    # Gateway logouts redirect to the service param, so it must be a registered
    # service. Anything else falls back to the CAS login page, which then refuses
    # unknown services itself.
    [
      ["an unregistered host", "https://evil.example.org/"],
      ["a protocol-relative URL", "//evil.example.org/"],
      ["userinfo naming a registered host", "https://client.example.com@evil.example.org/x"],
      ["a scheme-less value", "client.example.com/app"],
      ["a bare userinfo-style value", "@evil.example.org"],
      ["a different scheme", "http://client.example.com/app"]
    ].each do |label, service|
      it "does not redirect gateway logouts to #{label}" do
        get "/cas/logout", params: { service: service, gateway: "true" }
        assert_response :redirect
        refute_match(/evil\.example\.org/, URI.parse(response.location).host.to_s, "service=#{service}")
        assert_equal "/cas/login", URI.parse(response.location).path, "service=#{service}"
      end
    end
  end
end
