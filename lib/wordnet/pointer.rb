module WordNet
  class Pointer
    attr_reader :symbol, :offset, :pos, :source, :target

    # Create a pointer. Pointers represent the relations between the words in one synset and another,
    # and are referenced by a shorthand symbol (e.g. '!' for verb antonym). The list
    # of valid pointers is defined in pointers.rb
    def initialize(symbol: raise, offset: raise, pos: raise, source: raise)
      @symbol, @offset, @pos, @source = symbol, offset, pos, source
      @target = source.slice!(2,2)
    end

    def is_semantic?
      source == "00" && target == "00"
    end
  end
end
