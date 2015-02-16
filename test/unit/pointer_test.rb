require_relative "../test_helper"

describe WordNet::Pointer do
  let(:pointer) { WordNet::Pointer.new }

  describe "#method_missing" do
    it "misses unknown" do
      assert_raises NoMethodError do
        pointer.no
      end
    end

    it "does not miss things set to nil" do
      pointer[:no] = nil
      pointer.no.must_equal nil
    end

    it "does not miss things set" do
      pointer[:no] = 1
      pointer.no.must_equal 1
    end
  end

  describe "#respond_to?" do
    it "misses unknown" do
      pointer.respond_to?(:no).must_equal false
    end

    it "does not miss things set to nil" do
      pointer[:no] = nil
      pointer.respond_to?(:no).must_equal true
    end

    it "does not miss things set" do
      pointer[:no] = 1
      pointer.respond_to?(:no).must_equal true
    end

    it "supports include_all" do
      pointer[:no] = 1
      pointer.respond_to?(:no, true).must_equal true
    end
  end
end
