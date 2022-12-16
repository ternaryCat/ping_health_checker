# frozen_string_literal: true

Container.register_provider(:dry) do
  prepare do
    require 'dry/monads'
    require 'dry/schema'

    Dry::Schema.load_extensions(:monads)
  end
end
