require 'wordnet'

puts 'hiking'
WordNet::Synset.find_all('hiking').each{|d| puts d}

puts''
puts 'dogs'
WordNet::Synset.find_all('dogs').each{|d| puts d}
