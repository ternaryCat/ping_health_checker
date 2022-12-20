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
    end
  end
end
