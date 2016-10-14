require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Datoca
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.available_locales = [:en, :'pt-BR']
    config.i18n.default_locale = :'pt-BR'
  end

  def self.defaults
    @defaults ||= OpenStruct.new(
      YAML.load_file(
        File.join(Rails.root, 'config', 'app.yml')
      )[Rails.env]
    )
  end
end
