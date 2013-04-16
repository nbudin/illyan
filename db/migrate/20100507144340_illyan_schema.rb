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
      
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Encryptable
      t.string :password_salt

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
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
