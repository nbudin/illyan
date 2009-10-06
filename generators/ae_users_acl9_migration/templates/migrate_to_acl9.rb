class AeUsersAcl9Migration< ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string "name"
      t.string "authorizable_type"
      t.integer "authorizable_id"
      t.timestamps
    end
    
    # Populate roles from existing permission names
    superadmin = Role.create!(:name => "superadmin")
    blanket_roles = {}
    AeUsers.permissioned_classes.each do |klass|
      klass.permission_names.each do |perm_name|
        klass.all.each do |obj|
          Role.create!(:name => perm_name, :authorizable => obj)
        end
        blanket_roles[klass] = Role.create!(:name => "#{perm_name}_#{klass.name.tableize}")
      end
    end
    
    create_table :people_roles, :id => false do |t|
      t.integer "person_id"
      t.integer "role_id"
    end
    
    ActiveRecord::Base.conection.execute("INSERT INTO people_roles (person_id, role_id)
                                         SELECT person_id, roles.id FROM permissions
                                         LEFT JOIN roles ON
                                          (roles.name = permissions.permission
                                           AND authorizable_type = permissioned_type
                                           AND authorizable_id = permissioned_id)
                                         WHERE person_id IS NOT NULL
                                         AND permissioned_type IS NOT NULL
                                         AND permissioned_id IS NOT NULL
                                         AND permission IS NOT NULL")
    
    ActiveRecord::Base.conection.execute("INSERT INTO people_roles (person_id, role_id)
                                         SELECT person_id, ? FROM permissions
                                         WHERE person_id IS NOT NULL
                                         AND permissioned_type IS NULL
                                         AND permissioned_id IS NULL
                                         AND permission IS NULL", superadmin.id)
  
    blanket_roles.values.each do |role|
      ActiveRecord::Base.conection.execute("INSERT INTO people_roles (person_id, role_id)
                                           SELECT person_id, ? FROM permissions
                                           WHERE person_id IS NOT NULL
                                           AND permissioned_type IS NULL
                                           AND permissioned_id IS NULL
                                           AND permission = ?", role.id, role.name)
    end
    
    create_table :groups_roles, :id => false do |t|
      t.integer "group_id"
      t.integer "role_id"
    end
    
    ActiveRecord::Base.conection.execute("INSERT INTO groups_roles (group_id, role_id)
                                         SELECT role_id, roles.id FROM permissions
                                         LEFT JOIN roles ON
                                          (roles.name = permissions.permission
                                           AND authorizable_type = permissioned_type
                                           AND authorizable_id = permissioned_id)
                                         WHERE role_id IS NOT NULL
                                         AND permissioned_type IS NOT NULL
                                         AND permissioned_id IS NOT NULL
                                         AND permission IS NOT NULL")
    
    ActiveRecord::Base.conection.execute("INSERT INTO groups_roles (groups_id, role_id)
                                         SELECT role_id, ? FROM permissions
                                         WHERE role_id IS NOT NULL
                                         AND permissioned_type IS NULL
                                         AND permissioned_id IS NULL
                                         AND permission IS NULL", superadmin.id)
  
    blanket_roles.values.each do |role|
      ActiveRecord::Base.conection.execute("INSERT INTO groups_roles (group_id, role_id)
                                           SELECT role_id, ? FROM permissions
                                           WHERE role_id IS NOT NULL
                                           AND permissioned_type IS NULL
                                           AND permissioned_id IS NULL
                                           AND permission = ?", role.id, role.name)
    end
    
    drop_table :permissions
  end
  
  def self.down
  end
end