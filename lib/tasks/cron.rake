task :cron => :environment do
  if Time.now.hour == 0
    Rake::Task["illyan:cleanup"].invoke
  end
end
