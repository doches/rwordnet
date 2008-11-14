# Use WordNet as a command-line dictionary.
require 'rubygems'
require 'wordnet'

if ARGV.size != 1
  puts "Usage: ruby dictionary.rb word"
  exit(1)
end

word = ARGV[0]

# Find all the lemmas for a word (i.e., whether it occurs as a noun, verb, etc.)
lemmas = WordNet::WordNetDB.find(word)

# Print out each lemma with a list of possible meanings.
lemmas.each do |lemma| 
  puts lemma
  lemma.synsets.each_with_index do |synset,i|
    puts "\t#{i+1}) #{synset.gloss}"
  end
end
