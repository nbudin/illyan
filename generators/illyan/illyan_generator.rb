class IllyanGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory "public/images/illyan"
      %w{add admin group logout remove user}.each do |img|
        m.file "#{img}.png", "public/images/illyan/#{img}.png"
      end
      m.file "openid.gif", "public/images/illyan/openid.gif"
      m.migration_template 'migration.rb', "db/migrate", :migration_file_name => 'illyan_local_tables'
    end
  end
end
