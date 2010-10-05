class MakePeopleInvitable < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.invitable
    end
    
    add_index :people, :invitation_token, :unique => true
  end

  def self.down
    remove_column :people, :invitation_token
    remove_column :people, :invited_at
  end
end
