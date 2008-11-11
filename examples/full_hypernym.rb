require 'rubygems'
require 'wordnet'

# Open the index file for nouns
index = WordNet::NounIndex.new
# Find the word 'fruit'
lemma = index.find("fruit")
# Find all the synsets for 'fruit', and pick the first one.
synset = lemma.synsets[0]
puts synset
# Print the full hypernym derivation for the first sense of 'fruit'.
synset.expanded_hypernym.each { |d| puts d }
