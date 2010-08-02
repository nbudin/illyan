namespace :illyan do
  task :cleanup => :environment do
    consumed_cutoff = Time.now.beginning_of_day - 1.week
    expired_cutoff = Time.now.beginning_of_day - 1.day
    %w{LoginTicket ProxyTicket ServiceTicket}.each do |model_name|
      model = eval("Castronaut::Models::#{model_name}") #ugh
      scope = model.where(["consumed_at < ? or (consumed_at is null and created_at < ?)", consumed_cutoff, expired_cutoff])
      puts "Cleaning up #{scope.count} #{model_name.pluralize}"
      scope.destroy_all
    end
  end
end
