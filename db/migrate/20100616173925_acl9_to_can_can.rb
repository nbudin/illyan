class Acl9ToCanCan < ActiveRecord::Migration
  class Role < ActiveRecord::Base
    has_and_belongs_to_many :people
    has_and_belongs_to_many :groups
    
    belongs_to :authorizable, :polymorphic => true
  end
  
  def self.up
    add_column :people, :admin, :boolean
    
    create_table :groups_owners, :id => false do |t|
      t.column :group_id, :integer
      t.column :owner_id, :integer
    end
    
    Role.where(name: 'admin').find_each do |role|
      role.people.each do |p|
        say "Granting admin rights to #{p.name}"
        p.admin = true
        p.save
      end
      
      if role.authorizable and role.authorizable.is_a? Group
        group = role.authorizable
        role.people.each do |p|
          say "Granting group ownership of #{group.name} to #{p.name}"
          group.owners << p
        end
        group.save
      end
    end
    
    drop_table :roles
    drop_table :people_roles
    drop_table :groups_roles
  end

  def self.down
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
    
    admin_role = Role.create :name => "admin"
    Person.where(admin: true).find_each do |p|
      say "Giving admin role to #{p.name}"
      admin_role.people << p
    end
    admin_role.save
    
    Group.all.each do |group|
      admin_role = Role.create :name => "admin", :authorizable => group
      group.owners.each do |owner|
        admin_role.people << owner
      end
      say "Creating admin role for #{group.name} with #{admin_role.people.size} people authorized"
      admin_role.save
    end
    
    remove_column :people, :admin
    drop_table :groups_owners
  end
end
