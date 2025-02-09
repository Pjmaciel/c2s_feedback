require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module C2SFeedback
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Define o fuso horário padrão para o Brasil (Ajuste conforme necessário)
    config.time_zone = 'America/Sao_Paulo'

    # Faz com que o Rails armazene as datas no banco de dados no fuso horário local
    config.active_record.default_timezone = :local

    config.autoload_lib(ignore: %w(assets tasks))


    config.active_job.queue_adapter = :sidekiq

  end
end
