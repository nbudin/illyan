require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Illyan
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # load_defaults 7.2 enables YJIT in production. Keep it off for now: it adds
    # memory overhead and we haven't sized the Fly machine for it. Revisit separately.
    config.yjit = false

    # Opt in to the Rails 8.1 to_time behavior (preserve the full timezone, not just the
    # offset). Rails 8.0 warns about any other value. The app doesn't call to_time and
    # uses UTC, so this changes nothing in practice.
    config.active_support.to_time_preserves_timezone = :zone

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
