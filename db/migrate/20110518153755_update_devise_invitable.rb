class UpdateDeviseInvitable < ActiveRecord::Migration
  def self.up
    change_column :people, :invitation_token, :string, :limit => 60

    change_table :people do |t|
      t.integer :invitation_limit
      t.integer :invited_by_id
      t.string :invited_by_type
    end
  end

  def self.down
    change_column :people, :invitation_token, :string, :limit => 20

    change_table :people do |t|
      t.integer :invitation_limit
      t.integer :invited_by_id
      t.string :invited_by_type
    end
  end
end
