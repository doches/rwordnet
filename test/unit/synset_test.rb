require File.dirname(__FILE__) + "/../test_helper.rb"

class TestSynset < Test::Unit::TestCase
  require File.dirname(__FILE__) + "/../path.rb"
  
  def setup
    WordNet::WordNet.path=WordNetPath
    index = WordNet::NounIndex.new
    lemma = index.find("fruit")
    @synsets = lemma.get_synsets
  end
  
  test 'get synsets for a lemma' do
    assert_equal 3, @synsets.size
    assert_equal "(n) fruit (the ripened reproductive body of a seed plant)",@synsets[0].to_s
    assert_equal "an amount of a product",@synsets[1].gloss
  end
  
  test 'get hypernym for a synset' do
    hypernym = @synsets[0].get_relation(WordNet::Hypernym)
    hypernym = @synsets[0].hypernym
    assert_equal 1,hypernym.size
    assert_equal "(n) reproductive structure (the parts of a plant involved in its reproduction)",hypernym[0].to_s
  end

  test 'test shorthand for get_relation' do
    hypernym = @synsets[0].get_relation(WordNet::Hypernym)
    hypernym2 = @synsets[0].hypernym
    assert_equal hypernym[0].gloss, hypernym2[0].gloss
  end
  
  test 'get hyponyms for a synset' do
    hyponym = @synsets[0].get_relation(WordNet::Hyponym)
    assert_equal 29,hyponym.size
    assert_equal "fruit of various buckthorns yielding dyes or pigments",hyponym[26].gloss
  end
end
