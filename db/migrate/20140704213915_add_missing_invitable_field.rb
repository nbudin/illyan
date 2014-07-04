class AddMissingInvitableField < ActiveRecord::Migration
  def change
    add_column :people, :invitation_created_at, :datetime
  end
end
