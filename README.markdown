# A pure Ruby interface to WordNet #

[![Build Status](https://travis-ci.org/doches/rwordnet.png)](https://travis-ci.org/doches/rwordnet)

## Summary ##

+ Works directly on the database that comes with WordNet
+ No gem or native dependencies
+ *Very* easy to install
+ Small footprint (8.1M vs 24M for Ruby-Wordnet+DB)
+ Can use a custom, existing WordNet installation

## About ##

This library implements a pure Ruby interface to the WordNet lexical/semantic
database. Unlike existing ruby bindings, this one doesn't require you to convert
the original WordNet database into a new database format; instead it can work directly
on the database that comes with WordNet.

If you're doing something data-intensive you will achieve much better performance
with Michael Granger's [Ruby-WordNet](http://www.deveiate.org/projects/Ruby-WordNet/),
since it converts the WordNet database into a BerkelyDB file for quicker access.  rwordnet has a much smaller footprint, with no gem or native dependencies, and requires about a third of the space on disk as Ruby-Wordnet + DB. In
writing rwordnet, I've focused more on usability and ease of installation ( *gem install
rwordnet* ) at the expense of some performance. Use at your own risk, etc.

## Installation ##

One of the chief benefits of rwordnet over Ruby-WordNet is how easy it is to install:

    gem install rwordnet

That's it! rwordnet comes bundled with the WordNet database which it uses by default,
so there's absolutely nothing else to download, install, or configure.
Of course, if you want to use your own WordNet installation, that's easy too -- just
set the path to WordNet's database files before using the library (see examples below).

## Usage ##

The other benefit of rwordnet over Ruby-WordNet is that it's so much easier (IMHO) to
use.

As an example, consider finding all of the noun glosses for a given word:

```Ruby
require 'wordnet'

index = WordNet::NounIndex.instance
lemma = index.find("fruit")
lemma.synsets.each { |synset| puts synset.gloss }
```

...or all of the glosses, period:

```Ruby
lemmas = WordNet::DB.find("fruit")
synsets = lemmas.map { |lemma| lemma.synsets }
words = synsets.flatten
words.each { |word| puts word.gloss }
```

Have your own WordNet database that you've marked up with extra attributes and whatnot?
No problem:

```Ruby
require 'wordnet'

WordNet::DB.path = "/path/to/WordNet-3.0"
lemmas = WordNet::DB.find("fruit")
...
```
