class WidenPeopleInvitationToken < ActiveRecord::Migration[7.2]
  # Devise stores a 64-character digest of the invitation token, which doesn't
  # fit in the original varchar(60) column.
  def up
    change_column :people, :invitation_token, :string, limit: nil
  end

  def down
    change_column :people, :invitation_token, :string, limit: 60
  end
end
