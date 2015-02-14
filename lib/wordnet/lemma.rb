module WordNet
  # Represents a single word in the WordNet lexicon, which can be used to look up a set of synsets.
  class Lemma
    SPACE = ' '
    attr_accessor :word, :pos, :pointer_symbols, :tagsense_count, :synset_offsets, :id

    # Create a lemma from a line in an lexicon file. You should be creating Lemmas by hand; instead,
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

    def to_s
      [@word, @pos].join(",")
    end

    class << self
      @@cache = {}

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
