# frozen_string_literal: true

class TestJob
  include Sidekiq::Job  # 🔥 Garante que o job seja processado pelo Sidekiq

  def perform
    puts "✅ Sidekiq está funcionando!"
  end
end
