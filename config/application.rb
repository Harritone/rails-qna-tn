require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths << config.root.join('lib', 'validators')
    config.autoload_paths << config.root.join('lib', 'services')
    config.autoload_paths << config.root.join('app')
    config.active_job.queue_adapter = :sidekiq
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
    Rails.autoloaders.main.ignore(Rails.root.join('app/config/sphinxy.conf'))

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators do |g|
      g.test_framework :rspec
      g.view_specs        false
      g.helper_specs      false
      g.request_specs false
      g.routing_specs false
    end
  end
end
