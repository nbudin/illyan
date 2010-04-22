ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

Dir["#{File.dirname(__FILE__)}/../generators/*/templates/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/rails_app/db/migrate/*.rb"].each {|f| require f}
IllyanLocalTables.up
CreatePosts.up