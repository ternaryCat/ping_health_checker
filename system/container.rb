# frozen_string_literal: true

require 'dry/system'
require 'zeitwerk'

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development') }
  use :zeitwerk

  configure do |config|
  end
end
