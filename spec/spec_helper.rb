require 'rubygems'
require 'bundler'
Bundler.require(:default)

#require 'rspec/mocks/standalone'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'time'
require 'time_range'
require 'active_support'
require 'active_support/all'

RSpec.configure do |config|
  config.mock_with :rspec
end
