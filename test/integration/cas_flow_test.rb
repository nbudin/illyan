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

    # action_on_path_relative_redirect = :raise (load_defaults 8.1). Without it these
    # redirected to http://localhost@evil.example.com (which browsers read as
    # evil.example.com) and to a garbled hostname.
    it "refuses to redirect gateway logouts to malformed service URLs" do
      ["@evil.example.com", "client.example.com/app"].each do |service|
        get "/cas/logout", params: { service: service, gateway: "true" }
        assert_response 500, "service=#{service}"
        assert_nil response.location, "service=#{service}"
      end
    end
  end
end
