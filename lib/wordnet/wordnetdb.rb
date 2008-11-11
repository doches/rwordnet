module WordNet

# Represents the WordNet database, and provides some basic interaction.
class WordNetDB
  # By default, use the bundled WordNet
  @@path = File.join(File.dirname(__FILE__),"/../../WordNet-3.0/")

  # To use your own WordNet installation (rather than the one bundled with rwordnet:
  def WordNetDB.path=(path_to_wordnet)
    @@path = path_to_wordnet
  end
  
  # Returns the path to the WordNet installation currently in use. Defaults to the bundled version of WordNet.
  def WordNetDB.path
    @@path
  end
  
  # Look up a word in WordNet. Returns a list of lemmas occuring in any of the index files (noun, verb, adjective, adverb).
  def WordNetDB.find(word)
    lemmas = []
    [NounIndex, VerbIndex, AdjectiveIndex, AdverbIndex].each do |index|
      lemmas.push index.new.find(word)
    end
    return lemmas.flatten.reject { |x| x.nil? }
  end
end

end
