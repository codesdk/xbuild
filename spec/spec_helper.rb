require 'bundler/setup'
Bundler.setup

require 'byebug'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'xbuild'

RSpec.configure do |config|
  # some (optional) config here
end
