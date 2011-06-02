config_file = File.expand_path("../../illyan.yml", __FILE__)

if File.exist?(config_file)
  options = YAML.load(File.open(config_file))
  %w{site_title site_logo theme account_name}.each do |var|
    Illyan::Application.send("#{var}=", options[var]) unless options[var].blank?
  end
end