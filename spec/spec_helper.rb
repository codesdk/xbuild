require 'bundler/setup'
Bundler.setup

require 'xbuild'
require 'byebug'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

RSpec.configure do |config|
  # some (optional) config here
end
