module Metrics
  module Repositories
    class Ip
      include Import['database.connection']

      # create record
      #
      # @param address [String] - ip address
      # @param created_at [DateTime]
      # @return [Integer] record's id
      #
      # @example address('192.168.0.1', time.now) #=> 10
      def create(address, created_at)
        connection[:ips].insert(address:, created_at:)
      end
    end
  end
end
