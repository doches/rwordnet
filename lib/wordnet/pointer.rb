module WordNet
  class Pointer
    attr_reader :symbol, :offset, :pos, :source, :target

    def initialize(symbol, offset, pos, source)
      @symbol, @offset, @pos, @source = symbol, offset, pos, source
      @target = source.slice!(2,2)
    end

    def is_semantic?
      source == "00" && target == "00"
    end
  end
end
