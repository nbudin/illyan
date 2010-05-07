# This file is used by Rack-based servers to start the application.

use Rack::OpenID

require ::File.expand_path('../config/environment',  __FILE__)
run Illyan::Application
