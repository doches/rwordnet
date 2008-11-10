## A pure-Ruby interface to WordNet ##

This library implements a pure-Ruby interface to the WordNet lexical/semantic
database. Unlike existing ruby bindings, this one doesn't require you to convert 
the original WordNet database into a new database format; instead it can work directly
on the database that comes with WordNet.

If you're doing something data-intensive you will achieve much better performance
with Michael Granger's [Ruby-WordNet](http://www.deveiate.org/projects/Ruby-WordNet/), 
since it converts the WordNet database into a BerkelyDB file for quicker access. In writing *rwordnet*, I've focused more on usability and ease of installation (+gem install wordnet+) at the expense of some performance. Use at your own risk, etc.

## Usage ##

As a quick example, consider finding all of the glosses for a given word:

    require 'rubygems'
    require 'wordnet'
    
    index = WordNet::NounIndex.new
    lemma = index.find("fruit")
    lemma.synsets.each { |synset| puts synset.gloss }
