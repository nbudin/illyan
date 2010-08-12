class DropLegacyTables < ActiveRecord::Migration
  def self.up
    drop_table :accounts
    drop_table :email_addresses
  end

  def self.down
    create_table "accounts", :force => true do |t|
      t.integer   "person_id"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "email_addresses", :force => true do |t|
      t.string    "address"
      t.boolean   "primary"
      t.integer   "person_id"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end
  end
end
