module Metrics
  module Services
    class AddIp < Core::Services::Base
      include Import['time', repository: 'metrics.repositories.ip']

      VALIDATOR = Dry::Schema.Params do
        required(:address).value(Core::Types::IpAddress)
      end

      # Add ip to table for observing
      #
      # @param address [String] - ip v4 address
      # @return [Dry::Monads::Result]
      #
      # @example call('192.168.0.1') #=> Success
      # @example call('192.999.9.9') #=> Failure
      def call(address)
        data = yield validate(address)
        ip = yield find_deleted_ip(**data.to_h)
        if ip
          yield restore_ip(**data.to_h)
        else
          yield create_ip(**data.to_h)
        end
        start_address_observing(address)
      end

      private

      def validate(address)
        VALIDATOR.call(address:).to_monad
      end

      def find_deleted_ip(address:)
        Try[Sequel::Error] do
          repository.find_with_deleted(address)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def create_ip(address:)
        Try[Sequel::Error] do
          repository.create(address, time.now)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def restore_ip(ip)
        Try[Sequel::Error] do
          repository.restore(ip[:id])
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def start_address_observing(address)
        Metrics::Workers::PingIp.perform_async(address)
        Success()
      end
    end
  end
end
