module WordNet

class WordNet
  def WordNet.path=(path_to_wordnet)
    @@path = path_to_wordnet
  end
  
  def WordNet.path
    @@path
  end
end

end
