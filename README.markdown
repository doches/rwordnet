## A pure-Ruby interface to WordNet ##

This library implements a pure-Ruby interface to the WordNet lexical/semantic
database. Unlike existing ruby bindings, this one doesn't require you to convert 
the original WordNet database into a BerkeleyDB file; instead it can work directly
on the database that comes with WordNet.

## Usage ##

As a quick example, consider finding all of the glosses for a given word:

    require 'rubygems'
    require 'wordnet'
    
    index = WordNet::NounIndex.new
    lemma = index.find("fruit")
    lemma.synsets.each { |synset| puts synset.gloss }
