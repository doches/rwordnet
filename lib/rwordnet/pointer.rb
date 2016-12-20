module WordNet
  # Pointers represent the relations between the words in one synset and another.
  class Pointer
    # The symbol that devices the relationship this pointer represents, e.g. "!" for verb antonym. Valid
    # pointer symbols are defined in pointers.rb
    attr_reader :symbol

    # The offset, in bytes, of this pointer in WordNet's internal database.
    attr_reader :offset

    # The part of speech this pointer represents. One of 'n', 'v', 'a' (adjective), or 'r' (adverb).
    attr_reader :pos

    # The synset from which this pointer...points.
    attr_reader :source

    # The synset to which this pointer...points.
    attr_reader :target

    # Create a pointer. Pointers represent the relations between the words in one synset and another,
    # and are referenced by a shorthand symbol (e.g. '!' for verb antonym). The list
    # of valid pointer symbols is defined in pointers.rb
    def initialize(symbol: raise, offset: raise, pos: raise, source: raise)
      @symbol, @offset, @pos, @source = symbol, offset, pos, source
      @target = source.slice!(2,2)
    end

    def is_semantic?
      source == "00" && target == "00"
    end
  end
end
