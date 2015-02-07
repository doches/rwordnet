require 'rubygems'
require 'wordnet'

# Find the word 'fruit'
lemma = WordNet::Lemma.find("fruit", :noun)
# Find all the synsets for 'fruit', and pick the first one.
synset = lemma.synsets[0]
puts synset
# Print the full hypernym derivation for the first sense of 'fruit'.
synset.expanded_hypernym.each { |d| puts d }
