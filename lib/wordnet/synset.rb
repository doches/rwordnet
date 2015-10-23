module WordNet
  SYNSET_TYPES = {"n" => "noun", "v" => "verb", "a" => "adj", "r" => "adv"}

  # Represents a synset (or group of synonymous words) in WordNet. Synsets are related to each other by various (and numerous!)
  # relationships, including Hypernym (x is a hypernym of y <=> x is a parent of y) and Hyponym (x is a child of y)
  class Synset
    # Get the offset, in bytes, at which this synset's information is stored in WordNet's internal DB.
    # You almost certainly don't care about this.
    attr_reader :synset_offset

    # A two digit decimal integer representing the name of the lexicographer file containing the synset for the sense.
    # Probably only of interest if you're using a wordnet database marked up with custom attributes, and you
    # want to ensure that you're using your own additions.
    attr_reader :lex_filenum

    # Get the list of words (and their frequencies within the WordNet graph) contained
    # in this Synset.
    attr_reader :word_counts

    # Get the part of speech type of this synset. One of 'n' (noun), 'v' (verb), 'a' (adjective), or 'r' (adverb)
    attr_reader :synset_type

    # Get the offset, in bytes, at which this synset's POS information is stored in WordNet's internal DB.
    # You almost certainly don't care about this.
    attr_reader :pos_offset

    # Get a shorthand representation of the part of speech this synset represents, e.g. "v" for verbs.
    attr_reader :pos

    # Get a string representation of this synset's gloss. "Gloss" is a human-readable
    # description of this concept, often with example usage, e.g:
    #
    #    move upward; "The fog lifted"; "The smoke arose from the forest fire"; "The mist uprose from the meadows"
    #
    # for the second sense of the verb "fall"
    attr_reader :gloss

    # Create a new synset by reading from the data file specified by +pos+, at +offset+ bytes into the file. This is how
    # the WordNet database is organized. You shouldn't be creating Synsets directly; instead, use Lemma#synsets.
    def initialize(pos, offset)
      data_line = DB.open(File.join("dict", "data.#{SYNSET_TYPES.fetch(pos)}")) do |f|
        f.seek(offset)
        f.readline.strip
      end

      info_line, @gloss = data_line.split(" | ", 2)
      line = info_line.split(" ")

      @pos = pos
      @pos_offset = offset
      @synset_offset = line.shift
      @lex_filenum = line.shift
      @synset_type = line.shift

      @word_counts = {}
      word_count = line.shift.to_i
      word_count.times do
        @word_counts[line.shift] = line.shift.to_i
      end

      pointer_count = line.shift.to_i
      @pointers = Array.new(pointer_count).map do
        Pointer.new(
          symbol: line.shift[0],
          offset: line.shift.to_i,
          pos: line.shift,
          source: line.shift
        )
      end
    end

    # How many words does this Synset include?
    def word_count
      @word_counts.size
    end

    # Get a list of words included in this Synset
    def words
      @word_counts.keys
    end

    # Get an array of Synsets with the relation `pointer_symbol` relative to this
    # Synset. Mostly, this is an internal method used by convience methods (e.g. Synset#antonym), but
    # it can take any valid valid +pointer_symbol+ defined in pointers.rb.
    #
    # Example (get the gloss of an antonym for 'fall'):
    #     WordNet::Lemma.find("fall", :verb).synsets[1].relation("!")[0].gloss
    def relation(pointer_symbol)
      @pointers.select { |pointer| pointer.symbol == pointer_symbol }.
        map! { |pointer| Synset.new(@synset_type, pointer.offset) }
    end

    # Get the Synset of this sense's antonym
    def antonyms
      relation(ANTONYM)
    end

    # Get the parent synset (higher-level category, i.e. fruit -> reproductive_structure).
    def hypernym
      relation(HYPERNYM)[0]
    end

    # Get the parent synset (higher-level category, i.e. fruit -> reproductive_structure).
    def hypernyms
      relation(HYPERNYM)
    end

    # Get the child synset(s) (i.e., lower-level categories, i.e. fruit -> edible_fruit)
    def hyponyms
      relation(HYPONYM)
    end

    # Get the entire hypernym tree (from this synset all the way up to +entity+) as an array.
    def expanded_first_hypernyms
      parent = hypernym
      list = []
      return list unless parent

      while parent
        break if list.include? parent.pos_offset
        list.push parent.pos_offset
        parent = parent.hypernym
      end

      list.flatten!
      list.map! { |offset| Synset.new(@pos, offset)}
    end

    # Get the entire hypernym tree (from this synset all the way up to +entity+) as an array.
    def expanded_hypernyms
      parents = hypernyms
      list = []
      return list unless parents

      while parents.length > 0
        parent = parents.pop
        next if list.include? parent.pos_offset
        list.push parent.pos_offset
        parents.push *parent.hypernyms
      end

      list.flatten!
      list.map! { |offset| Synset.new(@pos, offset)}
    end

    # Returns a compact, human-readable form of this synset, e.g.
    #
    #    (v) fall (descend in free fall under the influence of gravity; "The branch fell from the tree"; "The unfortunate hiker fell into a crevasse")
    #
    # for the second meaning of the verb "fall."
    def to_s
      "(#{@synset_type}) #{words.map { |x| x.tr('_',' ') }.join(', ')} (#{@gloss})"
    end

    alias to_str to_s
    alias size word_count
    alias parent hypernym
    alias parents hypernyms
    alias children hyponyms
  end
end
