require 'rubygems'
require 'bundler'
Bundler.require(:default)

#require 'rspec/mocks/standalone'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'time_range'

RSpec.configure do |config|
  config.mock_with :rspec
end
