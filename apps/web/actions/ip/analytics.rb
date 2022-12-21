module Web
  module Actions
    module Ip
      class Analytics
        include Import['metrics.services.calculate_responses_analytics']

        def call(app, address)
          result = calculate_responses_analytics.call(address, app.params['start_datetime'], app.params['end_datetime'])
          return result.value! if result.success?

          'result.failure'
        end
      end
    end
  end
end
