class UpdateInvitableFields < ActiveRecord::Migration
  def change
    add_column :people, :invitation_accepted_at, :datetime
  end
end
