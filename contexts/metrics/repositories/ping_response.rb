module Metrics
  module Repositories
    class PingResponse
      include Import['database.connection']

      # creates record
      #
      # @param ip_id [Integer] - ip record's id
      # @param success [Boolean] - flag of successed ping
      # @param duration [Float]
      # @param created_at [DateTime]
      # @return [Integer] record's id
      #
      # @example address(12, true, 0.12, time.now) #=> 10
      # @example address(12, false, 0, time.now) #=> 11
      def create(ip_id, success, duration, created_at)
        connection[:ping_responses].insert(ip_id:, success:, duration:, created_at:)
      end

      # calculates average duration in time interval
      #
      # @param ip_id [Integer] - ip record's id
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Float]
      #
      # @example average_duration(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0.01112
      # @example average_duration(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0
      def average_duration(ip_id, start_datetime, end_datetime)
        successed_records_in_interval(ip_id, start_datetime, end_datetime).avg(:duration)
      end

      # find min duration in time interval
      #
      # @param ip_id [Integer] - ip record's id
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Float | NilClass]
      #
      # @example min_duration(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0.01112
      # @example min_duration(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> nil
      def min_duration(ip_id, start_datetime, end_datetime)
        successed_records_in_interval(ip_id, start_datetime, end_datetime).min(:duration)
      end

      # find max duration in time interval
      #
      # @param ip_id [Integer] - ip record's id
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Float | NilClass]
      #
      # @example max_duration(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0.01112
      # @example max_duration(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> nil
      def max_duration(ip_id, start_datetime, end_datetime)
        successed_records_in_interval(ip_id, start_datetime, end_datetime).max(:duration)
      end

      # median duration
      #
      # @param ip_id [Integer] - ip record's id
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Integer]
      #
      # @example not_successed_count(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0.0.056632014
      # @example not_successed_count(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0
      def median_duration(ip_id, start_datetime, end_datetime)
        successed_records_in_interval(ip_id, start_datetime, end_datetime).select(
          Sequel.lit("PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY duration) ")
        ).all.first[:percentile_cont]
      end

      # standard deviation duration
      #
      # @param ip_id [Integer] - ip record's id
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Integer]
      #
      # @example not_successed_count(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0.0.056632014
      # @example not_successed_count(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0
      def standard_deviation_duration(ip_id, start_datetime, end_datetime)
        successed_records_in_interval(ip_id, start_datetime, end_datetime).select(
          Sequel.function(:stddev_pop, :duration)
        ).all.first[:stddev_pop]
      end

      # standard deviation duration
      #
      # @param ip_id [Integer] - ip record's id
      # @param start_datetime [String]
      # @param end_datetime [String]
      # @return [Integer]
      #
      # @example not_successed_count(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 2.056632014
      # @example not_successed_count(11, '23.12.2022 00:00', '24.12.2022 23:59') #=> 0
      def loss_percent(ip_id, start_datetime, end_datetime)
        records_in_interval(ip_id, start_datetime, end_datetime).select(
          Sequel.case(
            {
              { Sequel.lit('COUNT(*)') => 0 } => 0
            },
            Sequel.lit('(100 - 100 * SUM(success::int)::float / COUNT(*)::float)')
          ).as(:failed_responses_percent)
        ).all.first[:failed_responses_percent]
      end

      private

      def successed_records_in_interval(ip_id, start_datetime, end_datetime)
        records_in_interval(ip_id, start_datetime, end_datetime).where(success: true)
      end


      def records_in_interval(ip_id, start_datetime, end_datetime)
        connection[:ping_responses].where(ip_id:)
                                   .where { created_at >= Sequel.string_to_datetime(start_datetime) }
                                   .where { created_at <= Sequel.string_to_datetime(end_datetime) }
      end
    end
  end
end
