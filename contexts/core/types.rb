module Core
  module Types
    include Dry.Types()

    IpAddress = String.constrained(format: /^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$/)
  end
end
