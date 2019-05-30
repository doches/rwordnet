module WordNet
  SYNSET_TYPES = {"n" => "noun", "v" => "verb", "a" => "adj", "r" => "adv"}
  MORPHOLOGICAL_SUBSTITUTIONS = {
      'noun' => [['s', ''], ['ses', 's'], ['ves', 'f'], ['xes', 'x'],
             ['zes', 'z'], ['ches', 'ch'], ['shes', 'sh'],
             ['men', 'man'], ['ies', 'y']],
      'verb' => [['s', ''], ['ies', 'y'], ['es', 'e'], ['es', ''],
             ['ed', 'e'], ['ed', ''], ['ing', 'e'], ['ing', '']],
      'adj' => [['er', ''], ['est', ''], ['er', 'e'], ['est', 'e']],
      'adv' => []}

  # Represents a synset (or group of synonymous words) in WordNet. Synsets are related to each other by various (and numerous!)
  # relationships, including Hypernym (x is a hypernym of y <=> x is a parent of y) and Hyponym (x is a child of y)
  class Synset
    @morphy_path = File.expand_path("../../../morphy/", __FILE__)
    @exception_map = {}

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

    # Ported from python NLTK
    # Load all synsets with a given lemma and part of speech tag.
    # If no pos is specified, all synsets for all parts of speech
    # will be loaded.
    # If lang is specified, all the synsets associated with the lemma name
    # of that language will be returned.
    def self.find(word, pos)
        word = word.downcase
        lemmas = self.morphy(word, pos).map{|form| WordNet::Lemma.find(form, pos)}
        lemmas.map{|lemma| lemma.synsets}.flatten
    end

    def self.find_all(word)
        SYNSET_TYPES.values.map{|pos| self.find(word, pos)}.flatten
    end

    def self.load_exception_map
        SYNSET_TYPES.each do |_, pos|
            @exception_map[pos] = {}
            File.open(File.join(@morphy_path, 'exceptions', "#{pos}.exc"), 'r').each_line do |line|
                line = line.split
                @exception_map[pos][line[0]] = line[1..-1]
            end
        end
    end

    def self._apply_rules(forms, pos)
        substitutions = MORPHOLOGICAL_SUBSTITUTIONS[pos]
        out = []
        forms.each do |form|
            substitutions.each do |old, new|
                if form.end_with? old
                    out.push form[0...-old.length] + new
                end
            end
        end
        return out
    end

    def self._filter_forms(forms, pos)
        forms.reject{|form| Lemma.find(form, pos).nil?}.uniq
    end

    # ported from nltk python
    # from jordanbg:
    # Given an original string x
    # 1. Apply rules once to the input to get y1, y2, y3, etc.
    # 2. Return all that are in the database
    # 3. If there are no matches, keep applying rules until you either
    #    find a match or you can't go any further
    def self.morphy(form, pos)
        if @exception_map == {}
            self.load_exception_map
        end
        exceptions = @exception_map[pos]

        # 0. Check the exception lists
        if exceptions.has_key? form
            return self._filter_forms([form] + exceptions[form], pos)
        end

        # 1. Apply rules once to the input to get y1, y2, y3, etc.
        forms = self._apply_rules([form], pos)

        # 2. Return all that are in the database (and check the original too)
        results = self._filter_forms([form] + forms, pos)
        if results != []
            return results
        end

        # 3. If there are no matches, keep applying rules until we find a match
        while forms.length > 0
            forms = self._apply_rules(forms, pos)
            results = self._filter_forms(forms, pos)
            if results != []
                return results
            end
        end

        # Return an empty list if we can't find anything
        return []
    end

    def self.morphy_all(form)
        SYNSET_TYPES.values.map{|pos| self.morphy(form, pos)}.flatten
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

    # Get the Synsets of this sense's antonym
    def antonyms
      relation(ANTONYM)
    end

    # Get the parent synset (higher-level category, i.e. fruit -> reproductive_structure).
    def hypernym
      relation(HYPERNYM)[0]
    end

    # Get the parent synset (higher-level category, i.e. fruit -> reproductive_structure)
    # as an array.
    def hypernyms
      relation(HYPERNYM)
    end

    # Get the child synset(s) (i.e., lower-level categories, i.e. fruit -> edible_fruit)
    def hyponyms
      relation(HYPONYM)
    end

    # Get the entire hyponym tree as an array
    def expanded_hyponyms
      children = self.hyponyms
      return [] if children.empty?
      
      return [children, children.collect{|child| child.expanded_hyponyms}.flatten].flatten
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

    def expanded_hypernyms_depth
      parents = hypernyms.map{|hypernym| [hypernym, 1]}
      list = []
      out = []
      return list unless parents

      max_depth = 1
      while parents.length > 0
        parent, depth = parents.pop
        next if list.include? parent.pos_offset
        list.push parent.pos_offset
        out.push [Synset.new(@pos, parent.pos_offset), depth]
        parents.push *(parent.hypernyms.map{|hypernym| [hypernym, depth + 1]})
        max_depth = [max_depth, depth].max
      end
      return [out, max_depth]
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
