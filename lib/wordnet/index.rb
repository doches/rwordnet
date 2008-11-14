module WordNet

# Index is a WordNet lexicon. Note that Index is the base class; you probably want to be using the NounIndex, VerbIndex, etc. classes instead.
class Index
  # Create a new index for the given part of speech. +pos+ can be one of +noun+, +verb+, +adj+, or +adv+.
  def initialize(pos)
    @pos = pos
    @db = {}
  end
  
  # Find a lemma for a given word. Returns a Lemma which can then be used to access the synsets for the word.
  def find(lemma_str)
    # Look for the lemma in the part of the DB already read...
    @db.each_key do |word|
      return @db[word] if word == lemma_str
    end
    
    # If we didn't find it, read in some more from the DB. Some optimisation is possible here. TODO.
    index = WordNetDB.open(File.join(WordNetDB.path,"dict","index.#{@pos}"))
    if not index.closed?
      loop do
        break if index.eof?
        line = index.readline
        lemma = Lemma.new(line)
        @db[lemma.word] = lemma
        if line =~ /^#{lemma_str} /
          return lemma
        end
      end
      index.close
    end
    
    return nil
  end
end

# An Index of nouns.
class NounIndex < Index
  def initialize
    super("noun")
  end
end

# An Index of verbs.
class VerbIndex < Index
  def initialize
    super("verb")
  end
end

# An Index of adjectives.
class AdjectiveIndex < Index
  def initialize
    super("adj")
  end
end

# An Index of adverbs.
class AdverbIndex < Index
  def initialize
    super("adv")
  end
end

end
