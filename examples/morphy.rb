require 'rwordnet'

puts 'dogs'
puts '--------------'
puts 'as noun'
p WordNet::Synset.morphy('dogs', 'noun')
puts 'as verb'
p WordNet::Synset.morphy('dogs', 'verb')


puts ''
puts 'hiking'
puts '--------------'
puts 'as noun'
p WordNet::Synset.morphy('hiking', 'noun')
puts 'as verb'
p WordNet::Synset.morphy('hiking', 'verb')
puts 'as all'
p WordNet::Synset.morphy_all('hiking')

