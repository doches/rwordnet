require_relative "../test_helper"

describe WordNet::Lemma do
  describe ".find" do
    it 'finds a lemma by string' do
      lemma = WordNet::Lemma.find("fruit", :noun)
      lemma.to_s.must_equal "fruit,n"
    end

    it 'caches found' do
      lemma1 = WordNet::Lemma.find("fruit", :noun)
      lemma2 = with_db_path "does-not-exist" do
        WordNet::Lemma.find("fruit", :noun)
      end
      lemma1.word.must_equal lemma2.word
    end

    it 'only scans the db once' do
      lemma1 = WordNet::Lemma.find("fruit", :noun)
      lemma2 = with_db_path "does-not-exist" do
        WordNet::Lemma.find("table", :noun)
      end
      lemma2.word.must_equal "table"
    end

    it 'can lookup different things' do
      lemma1 = WordNet::Lemma.find("fruit", :noun)
      lemma2 = WordNet::Lemma.find("banana", :noun)
      lemma1.word.must_equal "fruit"
      lemma2.word.must_equal "banana"
    end

    it 'does not find word in wrong file' do
      lemma = WordNet::Lemma.find("elephant", :verb)
      lemma.must_equal nil
    end

    it 'caches unfound' do
      WordNet::Lemma.find("elephant", :verb)
      lemma2 = with_db_path "does-not-exist" do
        WordNet::Lemma.find("elephant", :verb)
      end
      lemma2.must_equal nil
    end

    it 'fails on unknown type' do
      assert_raises Errno::ENOENT do
        WordNet::Lemma.find("fruit", :sdjksdfjkdfskjsdfjk)
      end
    end

    it "does not find by regexp" do
      WordNet::Lemma.find(".", :verb).must_equal nil
    end
  end

  describe ".find_all" do
    it "finds all pos" do
      result = WordNet::Lemma.find_all("fruit")
      result.size.must_equal 2
      result.map(&:pos).sort.must_equal ["n", "v"]
    end

    it "returns empty array for unfound" do
      WordNet::Lemma.find_all("sdjkhdfsjfdsjhkfds").must_equal []
    end

    it "does not produce a circular reference" do
      l = WordNet::Lemma.find_all("blink")[1]
      l.synsets[1].expanded_first_hypernyms.wont_be_nil
    end
  end

  describe "#synsets" do
    it 'finds them' do
      lemma = WordNet::Lemma.find("fruit", :noun)
      synsets = lemma.synsets
      synsets.size.must_equal 3
      synsets[1].to_s.must_equal "(n) yield, fruit (an amount of a product)"
    end
  end

  describe ".new" do
    it "builds all fields" do
      lemma = WordNet::Lemma.new("fruit n 3 3 @ ~ + 3 3 13134947 04612722 07294550", 123)
      lemma.id.must_equal 123
      lemma.word.must_equal "fruit"
      lemma.pos.must_equal "n"
      lemma.pointer_symbols.must_equal ["@", "~", "+"]
      lemma.tagsense_count.must_equal 3
      lemma.synset_offsets.must_equal [13134947, 4612722, 7294550]
    end
  end
end
