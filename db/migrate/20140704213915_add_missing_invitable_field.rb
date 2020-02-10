class AddMissingInvitableField < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :invitation_created_at, :datetime
  end
end
