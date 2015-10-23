require 'wordnet'

# Find the word 'dog'
lemma = WordNet::Lemma.find("dog", :noun)
# Find all the synsets for 'dog', and pick the first one.
synset = lemma.synsets[0]
puts synset
# Print the full hypernym derivation for the first sense of 'dog'.
synset.expanded_hypernyms.each { |d| puts d }
