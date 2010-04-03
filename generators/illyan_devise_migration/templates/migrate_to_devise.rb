class IllyanDeviseMigration < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.database_authenticatable
      t.rememberable
      t.confirmable
      t.recoverable
      t.trackable
    end

    execute "UPDATE people, email_addresses SET people.email = email_addresses.address WHERE people.id = email_addresses.person_id AND email_addresses.primary = 1"
    drop_table :email_addresses

    add_column :people, :legacy_password_md5, :string
    execute <<-EOF
    UPDATE people, accounts
    SET people.legacy_password_md5 = accounts.password
    WHERE people.id = accounts.person_id
    EOF

    execute <<-EOF
    UPDATE people, accounts
    SET people.confirmed_at = now()
    WHERE people.id = accounts.person_id
    AND accounts.active = 1
    EOF
    drop_table :accounts
  end

  def self.down
    throw ActiveRecord::IrreversibleMigration
  end
end