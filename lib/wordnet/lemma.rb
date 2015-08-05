module WordNet
  # Represents a single word in the WordNet lexicon, which can be used to look up a set of synsets.
  class Lemma
    SPACE = ' '

    # The word this lemma represents
    attr_accessor :word

    # The part of speech (noun, verb, adjective) of this lemma. One of 'n', 'v', 'a' (adjective), or 'r' (adverb)
    attr_accessor :pos

    # The number of times the sense is tagged in various semantic concordance texts. A tagsense_count of 0 indicates that the sense has not been semantically tagged.
    attr_accessor :tagsense_count

    # The offset, in bytes, at which the synsets contained in this lemma are stored in WordNet's internal database.
    attr_accessor :synset_offsets

    # A unique integer id that references this lemma. Used internally within WordNet's database.
    attr_accessor :id

    # An array of valid pointer symbols for this lemma. The list of all valid
    # pointer symbols is defined in pointers.rb.
    attr_accessor :pointer_symbols

    # Create a lemma from a line in an lexicon file. You should not be creating Lemmas by hand; instead,
    # use the WordNet::Lemma.find and WordNet::Lemma.find_all methods to find the Lemma for a word.
    def initialize(lexicon_line, id)
      @id = id
      line = lexicon_line.split(" ")

      @word = line.shift
      @pos = line.shift
      synset_count = line.shift.to_i
      @pointer_symbols = line.slice!(0, line.shift.to_i)
      line.shift # Throw away redundant sense_cnt
      @tagsense_count = line.shift.to_i
      @synset_offsets = line.slice!(0, synset_count).map(&:to_i)
    end

    # Return a list of synsets for this Lemma. Each synset represents a different sense, or meaning, of the word.
    def synsets
      @synset_offsets.map { |offset| Synset.new(@pos, offset) }
    end

    # Returns a compact string representation of this lemma, e.g. "fall, v" for
    # the verb form of the word "fall".
    def to_s
      [@word, @pos].join(",")
    end

    class << self
      @@cache = {}

      # Find all lemmas for this word across all known parts of speech
      def find_all(word)
        [:noun, :verb, :adj, :adv].flat_map do |pos|
          find(word, pos) || []
        end
      end

      # Find a lemma for a given word and pos
      def find(word, pos)
        cache = @@cache[pos] ||= build_cache(pos)
        if found = cache[word]
          Lemma.new(*found)
        end
      end

      private

      def build_cache(pos)
        cache = {}
        DB.open(File.join("dict", "index.#{pos}")).each_line.each_with_index do |line, index|
          word = line.slice(0, line.index(SPACE))
          cache[word] = [line, index+1]
        end
        cache
      end
    end
  end
end
