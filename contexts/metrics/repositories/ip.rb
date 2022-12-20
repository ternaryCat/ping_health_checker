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

      # find record by address
      #
      # @param address [String] - ip address
      # @return [Hash | NilClass] record or nil
      #
      # @example address('192.168.0.1') #=> {:id=>1, :address=>"192.168.0.1", :created_at=>2022-12-15 09:23:54.680421 +0000}
      # @example address('192.168.0.10') #=> nil
      def find(address)
        connection[:ips].where(address:).first
      end

      # select all addresses by batches
      #
      # @return [void]
      #
      # @example all { |address| puts(address) }
      def all_addresses(&block)
        connection[:ips].paged_each { |row| block.call(row[:address]) }
      end
    end
  end
end
