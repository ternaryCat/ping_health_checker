# frozen_string_literal: true

require 'dry/system'
require 'zeitwerk'

class Container < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development') }
  use :zeitwerk

  configure do |config|
    config.component_dirs.add 'contexts' do |dir|
      dir.memoize = true
    end

    config.component_dirs.add 'apps' do |dir|
      dir.memoize = true
    end

    config.component_dirs.add 'lib' do |dir|
      dir.memoize = true
    end
  end
end
