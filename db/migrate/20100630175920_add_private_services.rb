class AddPrivateServices < ActiveRecord::Migration[4.2]
  def self.up
    add_column "services", :public, :boolean
    add_index :services, :public

    create_table :services_users, :id => false do |t|
      t.integer :service_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :services_users, :user_id
  end

  def self.down
    drop_table :services_users
    remove_column "services", :public
  end
end
