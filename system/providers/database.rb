# frozen_string_literal: true

Container.register_provider(:database) do
  prepare do
    require 'sequel/core'
    require 'yaml'
    require 'erb'

    target.prepare :dotenv
    target.start :logger

    params = ERB.new(File.read('config/database.yml')).result
    config = YAML.safe_load(params, aliases: true)[Container.env]

    register('database.config', config)
  end

  start do
    database = Sequel.connect(logger: target['logger'], **target['database.config'])

    register('database.connection', database)
  end
end
