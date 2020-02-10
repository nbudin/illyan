class UpdateInvitableFields < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :invitation_accepted_at, :datetime
  end
end
