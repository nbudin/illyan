require 'test_helper'

class Cassy::ServiceTicketTest < ActiveSupport::TestCase
  setup do
    Cassy::ServiceTicket.delete_all
    @ticket_granting_ticket = Cassy::TicketGrantingTicket.create(:ticket => "TGT-12345678900987654321", :created_on => Time.now, :username => "1", :client_hostname => "http://sss.something.com", :extra_attributes => {})
    @service_ticket = Cassy::ServiceTicket.create!(:ticket => "ST-12345678901234567890", :consumed => false, :client_hostname => "http://sso.something.com", :granted_by_tgt => @ticket_granting_ticket, :service => "http://members.something.com", :username => "1")
  end

  it "should validate" do
    assert_equal(
      [
        @service_ticket,
        "Ticket 'ST-12345678901234567890' for 'http://members.something.com' for user '1' successfully validated."
      ],
      Cassy::ServiceTicket.validate_ticket(
        "http://members.something.com", "ST-12345678901234567890"
      )
    )
  end

  it "should not validate if the ticket has already been consumed" do
    @service_ticket.consume!
    assert_equal(
      [nil, "Ticket ST-12345678901234567890 has already been consumed."],
      Cassy::ServiceTicket.validate_ticket(
        "http://members.something.com", "ST-12345678901234567890"
      )
    )
  end

  it "should not validate if the ticket is too old" do
    @service_ticket.created_on = Time.now - 7201
    @service_ticket.save!
    assert_equal(
      [nil, "Ticket ST-12345678901234567890 has expired. Please try again."],
      Cassy::ServiceTicket.validate_ticket(
        "http://members.something.com", "ST-12345678901234567890"
      )
    )
  end

  it "should not validate if the ticket is invalid" do
    assert_equal(
      [nil, "Ticket 'ST-09876543210987654321' not recognized."],
      Cassy::ServiceTicket.validate_ticket("http://members.something.com", "ST-09876543210987654321")
    )
  end

  describe "#send_logout_notification" do
    it "should send valid single sign out XML to the service URL" do
      stub_request(:post, 'http://example.com')

      st = Cassy::ServiceTicket.new(
        ticket: 'ST-0123456789ABCDEFGHIJKLMNOPQRS',
        service: 'http://example.com',
        consumed: false,
        client_hostname: "http://sso.something.com"
      )

      st.send_logout_notification

      assert_requested(:post, 'example.com') do |req|
        xml = CGI.parse(req.body)['logoutRequest'].first
        Nokogiri::XML(xml).at_xpath('//samlp:SessionIndex').text.strip == st.ticket
      end
    end
  end
end
