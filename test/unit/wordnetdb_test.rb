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
end
