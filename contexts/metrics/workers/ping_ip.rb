# frozen_string_literal: true

module Metrics
  module Workers
    class PingIp
      include Sidekiq::Worker
      include Dry::Monads[:result]

      include Import['logger', 'metrics.services.ping_ip']

      # TODO: move to settings
      TIMEOUT = 5

      def perform(address)
        case ping_ip.call(address, TIMEOUT)
        when Success
          logger.info("successful ping: #{address}")
        when Failure(:doesnt_find_id)
          logger.error("ip: #{address} is not finded")
          return
        when Failure
          logger.error("failed ping: #{address}")
        end

        self.class.perform_async(address)
      end
    end
  end
end
