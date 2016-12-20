require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'simplecov'
module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_profile 'test_frameworks'
end

ENV["COVERAGE"] && SimpleCov.start do
  add_filter "/.rvm/"
end

require "bundler/setup"
require "maxitest/autorun"

$LOAD_PATH.unshift Bundler.root.join("lib")
require "rwordnet"

Minitest::Test.class_eval do
  def with_db_path(path)
    begin
      old, WordNet::DB.path = WordNet::DB.path, path
      yield
    ensure
      WordNet::DB.path = old
    end
  end
end
