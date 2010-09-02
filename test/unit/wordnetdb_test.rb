require File.dirname(__FILE__) + "/../test_helper.rb"

class TestWordNetDB < Test::Unit::TestCase
  include WordNet
  
  test 'set and read path' do
    WordNetDB.path = "WordNetPath"
    assert_equal "WordNetPath",WordNetDB.path
  end
  
  test 'find a word' do
    lemmas = WordNetDB.find("fruit")
    assert_equal 2,lemmas.size
  end
end
