require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ditotasker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1


    config.autoload_lib(ignore: %w(assets tasks))


    config.active_job.queue_adapter = :sidekiq

  end
end
