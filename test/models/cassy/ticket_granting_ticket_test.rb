require 'test_helper'

class Cassy::TicketGrantingTicketTest < ActiveSupport::TestCase
  before do
    Cassy::TicketGrantingTicket.delete_all
    @ticket_granting_ticket = Cassy::TicketGrantingTicket.create(:ticket => "TGT-12345678900987654321", :created_on => Time.now, :username => "1", :client_hostname => "http://sss.something.com", :extra_attributes => {})
  end

  it "should validate" do
    assert_equal(
      [
        @ticket_granting_ticket,
        "Ticket granting ticket 'TGT-12345678900987654321' for user '1' successfully validated."
      ],
      Cassy::TicketGrantingTicket.validate_ticket("TGT-12345678900987654321")
    )
  end

  it "should not validate if the ticket is too old" do
    @ticket_granting_ticket.created_on = Time.now-7201
    @ticket_granting_ticket.save!
    assert_equal(
      [nil, "Ticket TGT-12345678901234567890 has expired. Please log in again."],
      Cassy::TicketGrantingTicket.validate_ticket("TGT-12345678900987654321")
    )
  end

  it "should not validate if the ticket is invalid" do
    assert_equal(
      [nil, "Ticket 'TGT-09876543210987654321' not recognized."],
      Cassy::TicketGrantingTicket.validate_ticket("TGT-09876543210987654321")
    )
  end

  describe "single sign out" do
    before do
      @service_ticket = Cassy::ServiceTicket.create!(
        :granted_by_tgt_id => @ticket_granting_ticket.id,
        :service => "http://www.another.com",
        :ticket => "ST-1362563155rFE13971A3BCC04C6B5",
        :client_hostname => "another",
        :username => "1"
      )
      Cassy.config[:enable_single_sign_out] = true
    end

    it "sends a logout notification for all granted service tickets before being destroyed" do
      stub_request(:post, 'http://www.another.com')

      @ticket_granting_ticket.destroy_and_logout_all_service_tickets
      assert_requested(:post, 'www.another.com')

      assert_raises(ActiveRecord::RecordNotFound) do
        Cassy::TicketGrantingTicket.find(@ticket_granting_ticket.id)
      end
    end

    it "raises an error if single sign out is not enabled" do
      Cassy.config[:enable_single_sign_out] = false
      assert_raises(StandardError, "Single Sign Out is not enabled for Cassy. If you want to enable it, add 'enable_single_sign_out: true' to the Cassy config file.") do
        @ticket_granting_ticket.destroy_and_logout_all_service_tickets
      end
    end

    describe "logging in with a second session and 'no_concurrent_sessions' enabled" do
      before do
        Cassy.config[:no_concurrent_sessions] = true
        @ticket_granting_ticket = Cassy::TicketGrantingTicket.create!(
          :ticket => "TGT-981276451234567890",
          :username => "1",
          :client_hostname => "127.0.0.1",
          :extra_attributes => {}
        )
      end

      it "returns any ticket_granting_tickets that were created after the one stored in the session" do
        @second_ticket_granting_ticket = Cassy::TicketGrantingTicket.generate("1", nil, "127.0.0.1")
        assert @ticket_granting_ticket.not_the_latest_for_this_user?
      end

      it "should send a request to terminate the old session" do
        @second_ticket_granting_ticket = Cassy::TicketGrantingTicket.generate("1", nil, "127.0.0.1")
        assert @ticket_granting_ticket.granted_service_tickets.reload.all?(&:consumed)
      end
    end

    describe "logging in with a second session and 'no_concurrent_sessions' disabled" do
      before do
        Cassy::TicketGrantingTicket.delete_all
        Cassy.config[:no_concurrent_sessions] = nil
        @ticket_granting_ticket = Cassy::TicketGrantingTicket.create!(
          :ticket => "TGT-981276451234567890",
          :username => "1",
          :client_hostname => "127.0.0.1",
          :extra_attributes => {}
        )
      end

      it "should have two sessions" do
        @second_ticket_granting_ticket = Cassy::TicketGrantingTicket.generate("1", nil, "127.0.0.1")
        assert_equal 2, Cassy::TicketGrantingTicket.where(:username => "1").count
      end
    end

    it "returns the previous ticket for the username" do
      Cassy.config[:enable_single_sign_out] = true # otherwise they will be deleted
      @second_ticket_granting_ticket = Cassy::TicketGrantingTicket.generate("1", nil, "127.0.0.1")
      assert_equal @ticket_granting_ticket, @second_ticket_granting_ticket.previous_ticket
    end
  end
end
