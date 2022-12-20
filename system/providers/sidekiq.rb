# frozen_string_literal: true

Container.register_provider(:redis) do
  prepare do
    require 'sidekiq'
    require 'sidekiq/web'
    require 'rack/session'

    target.prepare :dotenv

    Sidekiq::Web.use Rack::Session::Cookie, secret: ENV['SIDEKIQ_SECRET']

    Sidekiq.configure_server do |config|
      config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
    end
  end
end
