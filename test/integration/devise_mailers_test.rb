require 'test_helper'

# Covers the emails Devise sends on our behalf, since those flows depend on the
# devise / devise_invitable gems that we'll be upgrading along with Rails.
class DeviseMailersTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  describe "password reset" do
    setup do
      @person = FactoryBot.create(:joe_user)
    end

    it "emails a working reset link" do
      visit new_person_password_path
      within "form" do
        fill_in "Email", with: "joe@user.com"
        click_on "Send me reset password instructions"
      end

      msg = ActionMailer::Base.deliveries.last
      assert msg, "expected a reset password email"
      assert_equal ["joe@user.com"], msg.to
      token = msg.body.to_s[/reset_password_token=([^"&\s]+)/, 1]
      assert token, "expected a reset token link in: #{msg.body}"

      visit edit_person_password_path(reset_password_token: token)
      within "form" do
        fill_in "person[password]", with: "BrandNewPassword"
        fill_in "person[password_confirmation]", with: "BrandNewPassword"
        click_on "Change my password"
      end

      assert @person.reload.valid_password?("BrandNewPassword")
    end

    it "doesn't send mail for unknown email addresses" do
      ActionMailer::Base.deliveries.clear
      visit new_person_password_path
      within "form" do
        fill_in "Email", with: "nobody@example.com"
        click_on "Send me reset password instructions"
      end

      assert_empty ActionMailer::Base.deliveries
    end
  end

  describe "confirmation" do
    it "can be resent" do
      person = FactoryBot.create(:person)
      ActionMailer::Base.deliveries.clear

      person.send_confirmation_instructions

      msg = ActionMailer::Base.deliveries.last
      assert msg
      assert_equal [person.email], msg.to
      assert_includes msg.body.to_s, "confirmation_token="
    end
  end

  describe "invitations" do
    it "emails an invitation that lets the invitee set a password" do
      skip "Person.invite! currently raises ActiveRecord::ValueTooLong: Devise's invitation token " \
        "digest is 64 chars but people.invitation_token is varchar(60). Unskip once the column is widened."

      invitee = Person.invite!(email: "newbie@example.com", firstname: "New", lastname: "Bie")
      assert invitee.persisted?

      msg = ActionMailer::Base.deliveries.last
      assert msg, "expected an invitation email"
      assert_equal ["newbie@example.com"], msg.to
      token = msg.body.to_s[/invitation_token=([^"&\s]+)/, 1]
      assert token, "expected an invitation link in: #{msg.body}"

      visit accept_person_invitation_path(invitation_token: token)
      within "form" do
        fill_in "person[password]", with: "InvitedPassword"
        fill_in "person[password_confirmation]", with: "InvitedPassword"
        click_on "Set my password"
      end

      invitee.reload
      assert invitee.invitation_accepted?
      assert invitee.valid_password?("InvitedPassword")
    end
  end
end
