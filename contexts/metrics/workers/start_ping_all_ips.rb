# frozen_string_literal: true

module Metrics
  module Workers
    class StartPingAllIps
      include Sidekiq::Worker

      include Import['metrics.workers.ping_addresses', repository: 'metrics.repositories.ip']

      def perform
        repository.all_addresses { |address| ping_address.perform_async(address) }
      end
    end
  end
end
