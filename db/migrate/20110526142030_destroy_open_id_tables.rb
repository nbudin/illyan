class DestroyOpenIdTables < ActiveRecord::Migration
  def self.up
    drop_table "open_id_identities"
  end

  def self.down
    create_table "open_id_identities", :force => true do |t|
      t.integer "person_id"
      t.string  "identity_url", :limit => 4000
    end

    add_index "open_id_identities", ["identity_url"], :name => "index_open_id_identities_on_identity_url"
  end
end
