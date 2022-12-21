module Web
  module Actions
    module Ip
      class Analytics
        include Import['metrics.services.calculate_responses_analytics']

        def call(app, address)
          result = calculate_responses_analytics.call(address, app.params['start_datetime'], app.params['end_datetime'])
          return { analytics: result.value! } if result.success?

          { error: result.failure.errors.to_h.inspect }
        end
      end
    end
  end
end
