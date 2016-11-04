require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Datoca
  def self.config
    @config ||= OpenStruct.new(
      YAML.load_file(
        File.join(Rails.root, 'config', 'app.yml')
      )[Rails.env]
    )
  end

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Brasilia'

    config.i18n.available_locales = [:en, :'pt-BR']
    config.i18n.default_locale = :'pt-BR'

    config.action_mailer.default_url_options = {
      host: Datoca.config.dig('action_mailer', 'host')
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:        Datoca.config.dig('smtp', 'address'),
      port:           Datoca.config.dig('smtp', 'port'),
      domain:         Datoca.config.dig('smtp', 'domain'),
      user_name:      Datoca.config.dig('smtp', 'user'),
      password:       Datoca.config.dig('smtp', 'pass'),
      authentication: Datoca.config.dig('smtp', 'auth')
    }
  end
end
