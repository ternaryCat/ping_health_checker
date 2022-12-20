require 'net/ping'

class Icmp
  # Pings ip address
  # @param ip [String] - ipv4 address
  # @param timeout [Integer] - timeout in seconds
  # @return [Hash] - set of ping duration (in seconds) and success flag
  #
  # @example ping('8.8.8.8') #=> { success: true, duration: 0.012 }
  # @example ping('8.8.8.8') #=> { success: false, duration: 0 }
  def ping(ip, timeout)
    # ip, port, timeout. port - always is nil in the Ping::ICMP source code, but there is it in initialize
    icmp = Net::Ping::ICMP.new(ip, nil, timeout)
    icmp.ping

    { success: !icmp.duration.nil?, duration: icmp.duration.to_f }
  end
end
