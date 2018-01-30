require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SportPortal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.generators.javascript_engine = :js

    # Set default language to German
    config.i18n.default_locale = :de

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add custom fonts-asset route
    Rails.application.config.assets.paths << "#{Rails.root}/app/assets/fonts"
    Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf .otf)

    #set new error page rout
    config.exceptions_app = self.routes
  end
end