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
    hypernym = synsets[0].relation(WordNet::HYPERNYM)
    hypernym = synsets[0].hypernym
    assert_equal 1,hypernym.size
    assert_equal "(n) reproductive structure (the parts of a plant involved in its reproduction)",hypernym.to_s
  end

  it 'test shorthand for get_relation' do
    hypernym = synsets[0].relation(WordNet::HYPERNYM)
    hypernym2 = synsets[0].hypernym
    assert_equal hypernym[0].gloss, hypernym2.gloss
  end

  it 'get hyponyms for a synset' do
    hyponym = synsets[0].relation(WordNet::HYPONYM)
    assert_equal 29,hyponym.size
    assert_equal "fruit of various buckthorns yielding dyes or pigments",hyponym[26].gloss
  end

  it 'test expanded hypernym tree' do
    expanded = synsets[0].expanded_first_hypernyms
    assert_equal 8, expanded.size
    assert_equal "entity", expanded[expanded.size-1].words[0]
  end

  it 'finds a correct antonym' do
    to_fall = WordNet::Lemma.find("fall", :verb).synsets[1]
    assert_includes to_fall.antonyms[0].words, "rise"
  end

  it 'finds hypernyms and hyponyms' do
    animal =  WordNet::Lemma.find("animal", :noun).synsets[0]
    assert_includes animal.hyponyms[0].words, "pest"
    assert_includes animal.hypernyms[0].words, "organism"
  end

  it 'lemmatises with morphy' do
    assert_includes WordNet::Synset.morphy('animals', 'noun'), "animal"
    assert_includes WordNet::Synset.morphy_all('animals'), "animal"
  end

  it 'returns an empty list for unmorphiable words' do
    assert_equal WordNet::Synset.morphy('not_a_word!#@', 'noun').size, 0
  end

  it 'finds lemmatised synsets' do
    take = WordNet::Synset.find_all('take').map { |x| x.words }.flatten
    assert_includes take, "claim"
    assert_includes take, "ingest"
  end

  it 'finds expanded hypernyms' do
    animal =  WordNet::Lemma.find("animal", :noun).synsets[0]
    assert_includes animal.expanded_hypernyms.map { |x| x.words }.flatten, "entity"
  end

  it 'finds expanded hypernyms with the right depth' do
    animal =  WordNet::Lemma.find("animal", :noun).synsets[0]
    assert_equal animal.expanded_hypernyms_depth[1], 6
  end
end
