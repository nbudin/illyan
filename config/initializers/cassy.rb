Cassy::Engine.config.config_file = File.expand_path("config/cassy.yml", Rails.root)

# Monkeypatch to make Cassy use Illyan's service model to look up valid services
module Cassy::CAS
  def valid_services
    Service.pluck :url
  end
end