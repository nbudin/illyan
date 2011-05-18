class IllyanSchema < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :person_id, :integer
      t.timestamps
    end
    
    create_table :email_addresses do |t|
      t.column :address, :string
      t.column :primary, :boolean
      t.column :person_id, :integer
      t.timestamps
    end
    
    create_table :groups do |t|
      t.column :name, :string
    end
    
    create_table :groups_people, :id => false do |t|
      t.column :person_id, :integer, :null => false
      t.column :group_id, :integer, :null => false
    end
    
    create_table :open_id_identities do |t|
      t.column :person_id, :integer
      t.column :identity_url, :string, :limit => 4000
    end
    
    create_table :people do |t|
      t.column :firstname, :string
      t.column :lastname, :string
      t.column :gender, :string
      t.column :birthdate, :datetime
      t.database_authenticatable
      t.encryptable
      t.rememberable
      t.confirmable
      t.recoverable
      t.trackable
      t.timestamps
    end
    
    create_table :roles do |t|
      t.string "name"
      t.string "authorizable_type"
      t.integer "authorizable_id"
      t.timestamps
    end
    
    create_table :people_roles, :id => false do |t|
      t.integer "person_id"
      t.integer "role_id"
    end
    
    create_table :groups_roles, :id => false do |t|
      t.integer "group_id"
      t.integer "role_id"
    end
  end

  def self.down
    drop_table :people
    drop_table :open_id_identities
    drop_table :groups_people
    drop_table :groups
    drop_table :email_addresses
    drop_table :accounts
    drop_table :groups_roles
    drop_table :people_roles
    drop_table :roles
  end
end
