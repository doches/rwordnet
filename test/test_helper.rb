require "bundler/setup"
require "maxitest/autorun"

$LOAD_PATH.unshift Bundler.root.join("lib")
require "wordnet"

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
