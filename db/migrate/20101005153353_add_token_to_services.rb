class AddTokenToServices < ActiveRecord::Migration
  def self.up
    change_table :services do |t|
      t.token_authenticatable
    end
    
    Service.all.map(&:ensure_authentication_token!)
    
    add_index :services, :authentication_token, :unique => true
  end

  def self.down
    remove_column :services, :authentication_token
  end
end
