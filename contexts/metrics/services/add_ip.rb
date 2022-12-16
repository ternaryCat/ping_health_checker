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
        create_ip(**data.to_h)
      end

      private

      def validate(address)
        VALIDATOR.call(address:).to_monad
      end

      def create_ip(address:)
        Try[Sequel::Error] do
          repository.create(address, time.now)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end
    end
  end
end
