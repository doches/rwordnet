require_relative "../test_helper"

describe WordNet::DB do
  it 'sets and reads path' do
    begin
      old, WordNet::DB.path = WordNet::DB.path, "WordNetPath"
      WordNet::DB.path.must_equal "WordNetPath"
    ensure
      WordNet::DB.path = old
    end
  end

  it 'finds a word' do
    lemmas = WordNet::DB.find("fruit")
    lemmas.size.must_equal 2
  end

  it 'does not produce a circular reference' do
    l = WordNet::DB.find("blink")[1]
    l.synsets[1].expanded_hypernym.wont_be_nil
  end
end
