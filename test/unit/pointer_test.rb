require_relative "../test_helper"

describe WordNet::Pointer do
  let(:pointer) { WordNet::Pointer.new("s", 123, "v", "1234") }

  describe "#initialize" do
    it "sets all values" do
      pointer.symbol.must_equal "s"
      pointer.offset.must_equal 123
      pointer.pos.must_equal "v"
      pointer.source.must_equal "12"
      pointer.target.must_equal "34"
    end
  end

  describe "#is_semantic?" do
    it "is not semantic for non-0" do
      pointer.is_semantic?.must_equal false
    end

    it "is semantic for all-0" do
      pointer = WordNet::Pointer.new("s", 123, "v", "0000")
      pointer.is_semantic?.must_equal true
    end
  end
end
