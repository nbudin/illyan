task :cron => :environment do
  Rake::Task["illyan:cleanup"].invoke
end
