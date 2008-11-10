require File.dirname(__FILE__) + "/../test_helper.rb"

class TestWordNetDB < Test::Unit::TestCase
  include WordNet

  require File.dirname(__FILE__) + "/../path.rb"
  
  test 'set and read path' do
    WordNetDB.path = WordNetPath
    assert_equal WordNetPath,WordNetDB.path
  end
  
  test 'find a word' do
    WordNetDB.path = WordNetPath
    lemmas = WordNetDB.find("fruit")
    assert_equal 2,lemmas.size
  end
end
