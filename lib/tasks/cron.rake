task :cron => :environment do
  Rake::Task["cassy:cleanup"].invoke
end
