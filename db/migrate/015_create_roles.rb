class CreateRoles < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.establish_connection AeUsers.environment
    create_table :roles do |t|
      t.column :name, :string, :null => false
    end
    create_table :people_roles, :id => false do |t|
      t.column :person_id, :integer, :null => false
      t.column :role_id, :integer, :null => false
    end
  end

  def self.down
    ActiveRecord::Base.establish_connection AeUsers.environment
    drop_table :roles
    drop_table :people_roles
  end
end
