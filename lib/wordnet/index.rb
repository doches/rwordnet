module WordNet

class Index
  # Create a new index for the given part of speech. +pos+ can be one of +noun+, +verb+, +adj+, or +adv+.
  def initialize(pos)
    @pos = pos
  end
  
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

class NounIndex < Index
  def initialize
    super("noun")
  end
end

class VerbIndex < Index
  def initialize
    super("verb")
  end
end

class AdjectiveIndex < Index
  def initialize
    super("adj")
  end
end

class AdverbIndex < Index
  def initialize
    super("adv")
  end
end

end
