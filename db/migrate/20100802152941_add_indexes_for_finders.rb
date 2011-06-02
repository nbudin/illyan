class AddIndexesForFinders < ActiveRecord::Migration
  def self.up
    add_index :people, :email
    add_index :open_id_identities, :identity_url
  end

  def self.down
    remove_index :people, :email
    remove_index :open_id_identities, :identity_url
  end
end
