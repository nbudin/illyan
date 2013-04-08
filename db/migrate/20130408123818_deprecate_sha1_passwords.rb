class DeprecateSha1Passwords < ActiveRecord::Migration
  def change
    change_table :people do |t|
      t.rename :encrypted_password, :legacy_password_sha1
      t.rename :password_salt, :legacy_password_sha1_salt
    end
    
    add_column :people, :encrypted_password, :string, :null => false, :default => ""
  end
end
