module Metrics
  module Services
    class CalculateResponsesAnalytics < Core::Services::Base
      include Import[
        ip_repository: 'metrics.repositories.ip',
        response_repository: 'metrics.repositories.ping_response'
      ]

      VALIDATOR = Dry::Schema.Params do
        required(:address).value(Core::Types::IpAddress)
        required(:start_datetime).value(Core::Types::Params::DateTime)
        required(:end_datetime).value(Core::Types::Params::DateTime)
      end

      # Calculates analtytics
      #
      # @param address [String] - ip v4 address
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Dry::Monads::Result]
      #
      # @example
      #   call('192.168.0.1', '23.12.2022 00:00', '24.12.2022 23:59') #=> Success(
      #      {
      #         min_duration: 0.001,
      #         max_duration: 0.0512,
      #         median_duration: 0.002,
      #         standard_deviation_duration: 0.02,
      #         packages_loss_percent: 20
      #      }
      #    )
      def call(address, start_datetime, end_datetime)
        data = yield validate(address, start_datetime, end_datetime)
        ip = yield find_ip(address)
        min = yield min_duration(ip, start_datetime, end_datetime)
        max = yield max_duration(ip, start_datetime, end_datetime)
        average = yield average_duration(ip, start_datetime, end_datetime)
        median = yield median_duration(ip, start_datetime, end_datetime)
        standard_deviation = yield standard_deviation_duration(ip, start_datetime, end_datetime)
        loss_percent = yield packages_loss_percent(ip, start_datetime, end_datetime)

        Success(
          {
            min_duration: min,
            max_duration: max,
            average_duration: average,
            median_duration: median,
            standard_deviation_duration: standard_deviation,
            packages_loss_percent: loss_percent
          }
        )
      end

      private

      def validate(address, start_datetime, end_datetime)
        VALIDATOR.call(address:, start_datetime:, end_datetime:).to_monad
      end

      def find_ip(address)
        Try[Sequel::Error] do
          ip_repository.find_with_deleted(address)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def min_duration(ip, start_datetime, end_datetime)
        Try[Sequel::Error] do
          response_repository.min_duration(ip[:id], start_datetime, end_datetime)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def max_duration(ip, start_datetime, end_datetime)
        Try[Sequel::Error] do
          response_repository.max_duration(ip[:id], start_datetime, end_datetime)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def average_duration(ip, start_datetime, end_datetime)
        Try[Sequel::Error] do
          response_repository.average_duration(ip[:id], start_datetime, end_datetime)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def median_duration(ip, start_datetime, end_datetime)
        Try[Sequel::Error] do
          response_repository.median_duration(ip[:id], start_datetime, end_datetime)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def standard_deviation_duration(ip, start_datetime, end_datetime)
        Try[Sequel::Error] do
          response_repository.standard_deviation_duration(ip[:id], start_datetime, end_datetime)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end

      def packages_loss_percent(ip, start_datetime, end_datetime)
        Try[Sequel::Error] do
          response_repository.loss_percent(ip[:id], start_datetime, end_datetime)
        end.to_result
           .or { |result| Failure([:db_error, result.exception.message]) }
      end
    end
  end
end
