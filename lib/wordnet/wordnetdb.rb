module WordNet

class WordNetDB
  def WordNetDB.path=(path_to_wordnet)
    @@path = path_to_wordnet
  end
  
  def WordNetDB.path
    @@path
  end
  
  def WordNetDB.find(word)
    lemmas = []
    [NounIndex, VerbIndex, AdjectiveIndex, AdverbIndex].each do |index|
      lemmas.push index.new.find(word)
    end
    return lemmas.flatten.reject { |x| x.nil? }
  end
end

end
