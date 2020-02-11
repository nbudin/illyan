require 'test_helper'

class Cassy::LoginTicketTest < ActiveSupport::TestCase
  setup do
    Cassy::LoginTicket.delete_all
    @login_ticket = Cassy::LoginTicket.create(:ticket => "ST-12345678901234567890", :consumed => false, :client_hostname => "http://sso.something.com")
  end

  it "should validate" do
    assert_equal(
      { valid: true },
      Cassy::LoginTicket.validate_ticket("ST-12345678901234567890")
    )
  end

  it "should not validate if the ticket has already been consumed" do
    @login_ticket.consume!
    assert_equal(
      {
        valid: false,
        error: "The login ticket you provided has already been used up. Please try logging in again."
      },
      Cassy::LoginTicket.validate_ticket("ST-12345678901234567890"),
    )
  end

  it "should not validate if the ticket is too old" do
    @login_ticket.created_on = Time.now - 7201
    @login_ticket.save!
    assert_equal(
      {
        valid: false,
        error: "You took too long to enter your credentials. Please try again."
      },
      Cassy::LoginTicket.validate_ticket("ST-12345678901234567890")
    )
  end

  it "should not validate if the ticket is invalid" do
    assert_equal(
      {
        valid: false,
        error: "The login ticket you provided is invalid. There may be a problem with the authentication system."
      },
      Cassy::LoginTicket.validate_ticket("ST-09876543210987654321")
    )
  end
end
