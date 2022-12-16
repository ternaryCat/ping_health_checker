# frozen_string_literal: true

Container.register_provider(:time) do
  start do
    register(:time, Time)
  end
end
