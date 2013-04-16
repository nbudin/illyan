class MakePeopleInvitable < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      ## Invitable
      t.string   :invitation_token, :limit => 60
      t.datetime :invitation_sent_at
      t.integer  :invitation_limit
      t.integer  :invited_by_id
      t.string   :invited_by_type
    end
    
    add_index :people, :invitation_token, :unique => true
  end

  def self.down
    remove_column :people, :invitation_token
    remove_column :people, :invited_at
  end
end
