class AddLegacyPasswordMd5 < ActiveRecord::Migration
  def self.up
    add_column :people, :legacy_password_md5, :string
  end

  def self.down
    remove_column :people, :legacy_password_md5
  end
end
