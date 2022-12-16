# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require './system/boot'
require_relative 'support/database_cleaning'
