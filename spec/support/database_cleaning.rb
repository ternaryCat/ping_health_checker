require 'database_cleaner-sequel'

# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner[:sequel].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end

  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end
end
