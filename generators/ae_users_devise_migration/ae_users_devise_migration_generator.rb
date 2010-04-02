class AeUsersDeviseMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migrate_to_devise.rb', "db/migrate", :migration_file_name => 'ae_users_devise_migration'
    end
  end
end