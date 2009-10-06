class RolesToGroups < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.establish_connection AeUsers.environment
    
    rename_table :roles, :groups
    rename_table :people_roles, :people_groups
    rename_column :people_groups, :role_id, :group_id
  end
  
  def self.down
    ActiveRecord::Base.establish_connection AeUsers.environment
    
    rename_column :people_groups, :group_id, :role_id
    rename_column :people_groups, :people_roles
    rename_column :groups, :roles
  end
end
