module WordNet
  # Represents a single word in the WordNet lexicon, which can be used to look up a set of synsets.
  class Lemma
    SPACE = ' '
    attr_accessor :lemma, :pos, :synset_cnt, :p_cnt, :ptr_symbol, :tagsense_cnt, :synset_offset, :id

    # Create a lemma from a line in an lexicon file. You should be creating Lemmas by hand; instead,
    # use the WordNet::Lemma.find and WordNet::Lemma.find_all methods to find the Lemma for a word.
    def initialize(lexicon_line, id)
      @id = id
      line = lexicon_line.split(" ")

      @lemma = line.shift
      @pos = line.shift
      @synset_cnt = line.shift.to_i
      @p_cnt = line.shift.to_i

      @ptr_symbol = []
      @p_cnt.times { @ptr_symbol.push line.shift }
      line.shift # Throw away redundant sense_cnt
      @tagsense_cnt = line.shift.to_i
      @synset_offset = []
      @synset_cnt.times { @synset_offset.push line.shift.to_i }
    end

    # Return a list of synsets for this Lemma. Each synset represents a different sense, or meaning, of the word.
    def synsets
      @synset_offset.map { |offset| Synset.new(@pos, offset) }
    end

    def to_s
      [@lemma, @pos].join(",")
    end

    alias word lemma

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
