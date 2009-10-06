namespace :ae_users do
  desc "create the database tables for the ae_users shared models"
  task :migrate_shared => :environment do
      ActiveRecord::Migrator.migrate(File.expand_path(File.dirname(__FILE__) + "/../db/migrate"))
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

  desc "remove the ae_users shared model tables from the database"
  task :rollback_shared => :environment do
    ActiveRecord::Migrator.down(File.expand_path(File.dirname(__FILE__) + "/../db/migrate"))
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end
end
