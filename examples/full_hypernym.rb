require 'rubygems'
require 'wordnet'

# Change this to point to your WordNet installation
WordNet::WordNet.path = "/home/doches/Code/WordNet/WordNet-3.0"

# Open the index file for nouns
index = WordNet::NounIndex.new
# Find the word 'fruit'
lemma = index.find("fruit")
# Find all the synsets for 'fruit', and pick the first one.
synset = lemma.synsets[0]

# Print the full hypernym derivation for the first sense of 'fruit'.
puts synset
depth = 2
loop do
  break if synset.nil?
  synset = synset.hypernym[0]
  depth.times { print " " }
  print "#{synset.to_s}\n"
  depth += 2
end
