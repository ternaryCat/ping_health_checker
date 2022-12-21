module Metrics
  module Services
    class DeleteIp < Core::Services::Base
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
      # @example call('192.168.0.2') #=> Failure
      def call(address)
        yield validate(address)
        ip = yield find_ip(address)
        delete_ip(ip)
      end

      private

      def validate(address)
        VALIDATOR.call(address:).to_monad
      end

      def find_ip(address)
        Try[Sequel::Error] do
          repository.find(address)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def delete_ip(ip)
        return Failure(:doesnt_find_id) unless ip

        repository.delete(ip[:id], time.now)
        Success()
      end
    end
  end
end
