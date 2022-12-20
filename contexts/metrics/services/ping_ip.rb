module Metrics
  module Services
    class PingIp < Core::Services::Base
      include Import[
        'icmp',
        'time',
        ip_repository: 'metrics.repositories.ip',
        response_repository: 'metrics.repositories.ping_response'
      ]

      VALIDATOR = Dry::Schema.Params do
        required(:address).value(Core::Types::IpAddress)
        required(:timeout).value(Core::Types::Timeout)
      end

      # Pings ip
      #
      # @param address [String] - ip v4 address
      # @param timeout [Integer] - timeout in seconds
      # @return [Dry::Monads::Result]
      #
      # @example call('192.168.0.1', 10) #=> Success(0.012)
      # @example call('192.999.9.9', 10) #=> Failure
      def call(address, timeout)
        data = yield validate(address, timeout)
        ip = yield find_ip(address)
        ip_id = yield extract_id(ip)
        response = yield ping(**data.to_h)
        create_response(**response.merge(ip_id:))
      end

      private

      def validate(address, timeout)
        VALIDATOR.call(address:, timeout:).to_monad
      end

      def find_ip(address)
        Try[Sequel::Error] do
          ip_repository.find(address)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def extract_id(ip)
        return Success(ip[:id]) if ip

        Failure(:doesnt_find_id)
      end

      def ping(address:, timeout:)
        Success(icmp.ping(address, timeout))
      end

      def create_response(success:, duration:, ip_id:)
        Try[Sequel::Error] do
          response_repository.create(ip_id, success, duration, time.now)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end
    end
  end
end
