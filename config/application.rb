require_relative 'boot'

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Bundler.require(:production)

module RecordStage
  class Application < Rails::Application
    RSpotify::authenticate(ENV['SPOTIFY_CLIENT'], ENV['SPOTIFY_SECRET'])
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.i18n.fallbacks = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
