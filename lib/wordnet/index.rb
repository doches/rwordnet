require 'singleton'
module WordNet

# Index is a WordNet lexicon. Note that Index is the base class; you probably want to be using the NounIndex, VerbIndex, etc. classes instead.
# Note that Indices are Singletons -- get an Index object by calling <POS>Index.instance, not <POS>Index.new.
class Index
  # Create a new index for the given part of speech. +pos+ can be one of +noun+, +verb+, +adj+, or +adv+.
  def initialize(pos)
    @pos = pos
    @db = {}
    
    @finished_reading = false
  end
  
  # Find a lemma for a given word. Returns a Lemma which can then be used to access the synsets for the word.
  def find(lemma_str)
    # Look for the lemma in the part of the DB already read...
    return @db[lemma_str] if @db.include?(lemma_str)
    
    return nil if @finished_reading
    
    # If we didn't find it, read in some more from the DB.
    index = WordNetDB.open(File.join(WordNetDB.path,"dict","index.#{@pos}"))

    lemma_counter = 1
    if not index.closed?
      loop do
        break if index.eof?
        line = index.readline
        lemma = Lemma.new(line, lemma_counter); lemma_counter += 1
        @db[lemma.word] = lemma
        if line =~ /^#{lemma_str} /
          return lemma
        end
      end
      index.close
    end
    
    @finished_reading = true
    
    # If we *still* didn't find it, return nil. It must not be in the database...
    return nil
  end
end

# An Index of nouns. Create a NounIndex by calling `NounIndex.instance`
class NounIndex < Index
  include Singleton
  
  def initialize
    super("noun")
  end
end

# An Index of verbs. Create a VerbIndex by calling `VerbIndex.instance`
class VerbIndex < Index
  include Singleton

  def initialize
    super("verb")
  end
end

# An Index of adjectives. Create an AdjectiveIndex by `AdjectiveIndex.instance`
class AdjectiveIndex < Index
  include Singleton

  def initialize
    super("adj")
  end
end

# An Index of adverbs. Create an AdverbIndex by `AdverbIndex.instance`
class AdverbIndex < Index
  include Singleton

  def initialize
    super("adv")
  end
end

end
