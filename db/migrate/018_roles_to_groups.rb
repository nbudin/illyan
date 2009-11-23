class RolesToGroups < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.establish_connection AeUsers.environment
    
    rename_table :roles, :groups
    rename_table :people_roles, :groups_people
    rename_column :groups_people, :role_id, :group_id
  end
  
  def self.down
    ActiveRecord::Base.establish_connection AeUsers.environment
    
    rename_column :groups_people, :group_id, :role_id
    rename_table :groups_people, :people_roles
    rename_table :groups, :roles
  end
end
