class AeUsersAcl9MigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migrate_to_acl9.rb', "db/migrate", :migration_file_name => 'ae_users_acl9_migration'
    end
  end
end