%w{site_title site_logo account_name}.each do |var|
  unless Illyan::Application.send(var)
    Illyan::Application.send("#{var}=", ENV["ILLYAN_#{var.upcase}"])
  end
end