module Web
  module Actions
    module Ip
      class Delete
        include Import['metrics.services.delete_ip']

        def call(_app, address)
          result = delete_ip.call(address)
          return { message: 'ip is deleted' } if result.success?

          { error: result.failure.errors.to_h.inspect }
        end
      end
    end
  end
end
