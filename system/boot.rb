require 'bundler'

ENV['RACK_ENV'] ||= 'deevelopment'
Bundler.setup(:default, ENV['RACK_ENV'])

require_relative 'import'
Container.finalize!
