# frozen_string_literal: true

require_relative 'system/container'

def migrate(version)
  Sequel.extension(:migration)

  Sequel::Migrator.apply(Container['database.connection'], 'db/migrations', version)

  Rake::Task['db:dump'].invoke
end

namespace :db do
  desc 'Migrate the database.'
  task :migrate do
    next if Dir.glob('./db/migrations/*.rb').empty?

    Container.start(:database)
    migrate(nil)
  end

  desc 'Rolling back latest migration.'
  task :rollback do |_, _args|
    Container.start(:database)
    current_version = Container['database.connection'].fetch('SELECT * FROM schema_info').first[:version]

    migrate(current_version - 1)
  end

  desc 'Dump database schema to file.'
  task :dump do
    next unless Container.env == 'development'

    Container.start(:database)
    Container['database.connection'].extension :schema_dumper
    File.write('db/schema.rb', Container['database.connection'].dump_schema_migration, nil , mode: 'w')
  end

  desc 'Create the database.'
  task :create do
    Container.prepare(:database)
    config = Container['database.config']

    Sequel.connect(config.merge('database' => nil)) do |db|
      if db.fetch("SELECT exists(SELECT datname FROM pg_catalog.pg_database WHERE datname = '#{config['database']}')")
           .first[:exists]
        puts '======= |The database is alreay created| ======='
      else
        db.execute "CREATE DATABASE #{config['database']}"
        puts '======= |The database is created| ======='
      end
    end
  end
end
