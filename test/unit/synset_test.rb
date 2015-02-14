require_relative "../test_helper"

describe WordNet::Synset do
  def self.synsets
    @synsets ||= WordNet::Lemma.find("fruit", :noun).synsets
  end

  let(:synsets) { self.class.synsets }

  it 'get synsets for a lemma' do
    assert_equal 3, synsets.size
    assert_equal "(n) fruit (the ripened reproductive body of a seed plant)",synsets[0].to_s
    assert_equal "an amount of a product",synsets[1].gloss
  end

  it 'get hypernym for a synset' do
    hypernym = synsets[0].get_relation(WordNet::HYPERNYM)
    hypernym = synsets[0].hypernym
    assert_equal 1,hypernym.size
    assert_equal "(n) reproductive structure (the parts of a plant involved in its reproduction)",hypernym.to_s
  end

  it 'test shorthand for get_relation' do
    hypernym = synsets[0].get_relation(WordNet::HYPERNYM)
    hypernym2 = synsets[0].hypernym
    assert_equal hypernym[0].gloss, hypernym2.gloss
  end

  it 'get hyponyms for a synset' do
    hyponym = synsets[0].get_relation(WordNet::HYPONYM)
    assert_equal 29,hyponym.size
    assert_equal "fruit of various buckthorns yielding dyes or pigments",hyponym[26].gloss
  end

  it 'test expanded hypernym tree' do
    expanded = synsets[0].expanded_hypernym
    assert_equal 8, expanded.size
    assert_equal "entity", expanded[expanded.size-1].words[0]
  end
end
