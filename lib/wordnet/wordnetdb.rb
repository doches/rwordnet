module WordNet

# Represents the WordNet database, and provides some basic interaction.
class WordNetDB
  # By default, use the bundled WordNet
  @@path = File.join(File.dirname(__FILE__),"/../../WordNet-3.0/")
  @@files = {}

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
      lemmas.push index.instance.find(word)
    end
    return lemmas.flatten.reject { |x| x.nil? }
  end
  
  # Register a new DB file handle. You shouldn't need to call this method; it's called automatically every time you open an index or data file.
  def WordNetDB.open(path)
    # If the file is already open, just return the handle.
    return @@files[path] if @@files.include?(path) and not @@files[path].closed?
    
    # Open and store 
    @@files[path] = File.open(path,"r")
    return @@files[path]
  end
  
  # You should call this method after you're done using WordNet.
  def WordNetDB.close
    WordNetDB.finalize(0)
  end
  
  def WordNetDB.finalize(id)
    @@files.each_value do |handle| 
      begin
        handle.close
      rescue IOError
        ; # Keep going, close the next file.
      end
    end
  end
end

end
