module Web
  module Actions
    module Ip
      class Delete
        include Import['metrics.services.delete_ip']

        def call(_app, address)
          result = delete_ip.call(address)
          return 'ip is deleted' if result.success?

          'ip is invalid'
        end
      end
    end
  end
end
