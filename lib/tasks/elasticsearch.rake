require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  task :create_index => :environment do
    [Person].each do |model|
      model.__elasticsearch__.create_index!
    end
  end
  
  task :create_and_import => [:create_index, "import:all"]
end