module Web
  module Actions
    module Ip
      class Create
        include Import['metrics.services.add_ip']

        def call(app)
          result = add_ip.call(app.params['address'])
          return { message: 'ip is added' } if result.success?

          { error: result.failure.errors.to_h.inspect }
        end
      end
    end
  end
end
