# frozen_string_literal: true

Container.register_provider(:dotenv) do
  prepare do
    require 'dotenv/load'
  end
end
