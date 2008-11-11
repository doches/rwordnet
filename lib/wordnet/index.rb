module WordNet

# Index is a WordNet lexicon. Note that Index is the base class; you probably want to be using the NounIndex, VerbIndex, etc. classes instead.
class Index
  # Create a new index for the given part of speech. +pos+ can be one of +noun+, +verb+, +adj+, or +adv+.
  def initialize(pos)
    @pos = pos
  end
  
  # Find a lemma for a given word. Returns a Lemma which can then be used to access the synsets for the word.
  def find(lemma_str)
    index = File.open(File.join(WordNetDB.path,"dict","index.#{@pos}"),"r")
    loop do
      line = index.readline
      if line =~ /^#{lemma_str} /
        index.close
        return Lemma.new(line)
      end
      break if index.eof?
    end
    index.close
    
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
