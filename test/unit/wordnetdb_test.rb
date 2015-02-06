require_relative "../test_helper"

describe WordNet::WordNetDB do
  it 'sets and reads path' do
    begin
      old, WordNet::WordNetDB.path = WordNet::WordNetDB.path, "WordNetPath"
      WordNet::WordNetDB.path.must_equal "WordNetPath"
    ensure
      WordNet::WordNetDB.path = old
    end
  end

  it 'finds a word' do
    lemmas = WordNet::WordNetDB.find("fruit")
    lemmas.size.must_equal 2
  end

  it 'does not produce a circular reference' do
    l = WordNet::WordNetDB.find("blink")[1]
    l.synsets[1].expanded_hypernym.wont_be_nil
  end
end
