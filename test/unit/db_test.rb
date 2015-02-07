require_relative "../test_helper"

describe WordNet::DB do
  it 'sets and reads path' do
    with_db_path("WordNetPath") { WordNet::DB.path.must_equal "WordNetPath" }
  end

  it "opens a relative path" do
    result = WordNet::DB.open(File.join("dict", "index.verb")) do |f|
      f.gets
    end
    result.must_equal "  1 This software and database is being provided to you, the LICENSEE, by  \n"
  end
end
