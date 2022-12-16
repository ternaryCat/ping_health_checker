module Web
  module Actions
    module Ip
      class Create
        include Import['metrics.services.add_ip']

        def call(app)
          result = add_ip.call(app['address'])
          return 'ip is added' if result.success?

          'ip is invalid'
        end
      end
    end
  end
end
