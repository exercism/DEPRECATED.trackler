ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start
SimpleCov.command_name "Run PID: #{$PROCESS_ID}"

gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
FIXTURE_PATH = "./test/fixtures".freeze
