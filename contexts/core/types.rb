module Core
  module Types
    include Dry.Types()

    MIN_TIMEOUT = 1
    MAX_TIMEOUT = 100

    Timeout = Types::Strict::Integer.constrained(gteq: MIN_TIMEOUT, lteq: MAX_TIMEOUT)
    IpAddress = String.constrained(format: /^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$/)
  end
end
