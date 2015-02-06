require_relative "../test_helper"

describe WordNet::NounIndex do
  let(:index) { WordNet::NounIndex.instance }

  it 'finds a lemma by string' do
    lemma = index.find("fruit")
    lemma.to_s.must_equal "fruit,n"
  end

  it 'gets synsets for a lemma' do
    lemma = index.find("fruit")
    synsets = lemma.get_synsets
    synsets.size.must_equal 3
    synsets[1].to_s.must_equal "(n) yield, fruit (an amount of a product)"
  end
end
