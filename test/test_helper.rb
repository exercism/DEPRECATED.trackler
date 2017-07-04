require 'English'
ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
  command_name "Run PID: #{$PROCESS_ID}"
end

gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'trackler/path'
FIXTURE_PATH = Trackler::Path.fixtures
