class AddIndexesForFinders < ActiveRecord::Migration
  def self.up
    add_index :people, :email
    add_index :open_id_identities, :identity_url
    add_index :services, :public
  end

  def self.down
    remove_index :people, :email
    remove_index :open_id_identities, :identity_url
    remove_index :services, :public
  end
end
