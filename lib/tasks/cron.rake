task :cron => :environment do
  Rake::Task["cassy:cleanup"].invoke
  Rake::Task["doorkeeper:db:cleanup"].invoke
end
