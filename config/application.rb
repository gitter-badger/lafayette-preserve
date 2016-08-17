require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'triplestore_adapter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LafayetteConcerns
  class Application < Rails::Application
    
    config.generators do |g|
      g.test_framework :rspec, :spec => true
    end

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :patch, :put, :delete]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    Rails.application.routes.default_url_options[:vocab_domain] = 'authority.lafayette.edu'
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/injectors) # Uncertain as to why this is needed
    config.autoload_paths += %W(#{config.root}/app/decorators)

    # config.triplestore_adapter.type = 'blazegraph'
    # config.triplestore_adapter.url = 'http://localhost'
    # Rails.application.triplestore_adapter[:type] = 'blazegraph'
    # Rails.application.triplestore_adapter[:url] = 'http://localhost'
    config.triplestore_adapter = { type: 'blazegraph', url: 'http://139.147.4.138:8084/bigdata/sparql' }
  end
end