require File.dirname(__FILE__) + "/../test_helper.rb"

class TestIndex < Test::Unit::TestCase
  @@index = nil
  
  def setup
    @@index = WordNet::NounIndex.instance if @@index.nil?
  end
  
  test 'find a lemma by string' do
    lemma = @@index.find("fruit")
    assert_equal "fruit,n",lemma.to_s
  end
  
  test 'get synsets for a lemma' do
    lemma = @@index.find("fruit")
    synsets = lemma.get_synsets
    assert_equal 3, synsets.size
    assert_equal "(n) yield, fruit (an amount of a product)",synsets[1].to_s
  end
end
