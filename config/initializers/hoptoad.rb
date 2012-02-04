api_key = ENV['HOPTOAD_API_KEY'] || Illyan::Application.config_vars['hoptoad_api_key']

if api_key
  HoptoadNotifier.configure do |config|
    config.api_key = api_key
  end
end
