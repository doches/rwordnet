# A pure Ruby interface to WordNet #

[![Gem Version](https://badge.fury.io/rb/rwordnet.svg)](http://badge.fury.io/rb/rwordnet)
[![Build Status](https://travis-ci.org/doches/rwordnet.png)](https://travis-ci.org/doches/rwordnet)
[![Documentation Status](https://inch-ci.org/github/doches/rwordnet.svg?branch=master)](https://inch-ci.org/github/doches/rwordnet)
[![Code Climate](https://codeclimate.com/github/doches/rwordnet/badges/gpa.svg)](https://codeclimate.com/github/doches/rwordnet)
[![Test Coverage](https://codeclimate.com/github/doches/rwordnet/badges/coverage.svg)](https://codeclimate.com/github/doches/rwordnet/coverage)

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

lemma = WordNet::Lemma.find("fruit", :noun)
lemma.synsets.each { |synset| puts synset.gloss }
```

...or all of the glosses, period:

```Ruby
lemmas = WordNet::Lemma.find_all("fruit")
synsets = lemmas.map { |lemma| lemma.synsets }
words = synsets.flatten
words.each { |word| puts word.gloss }
```

Have your own WordNet database that you've marked up with extra attributes and whatnot?
No problem:

```Ruby
require 'wordnet'

WordNet::DB.path = "/path/to/WordNet-3.0"
lemmas = WordNet::Lemma.find_all("fruit")
...
```

## Licensing ##

Because rwordnet bundles its own distribution of Wordnet, it's implicitly provided under the Wordnet (3.0) license. See LICENSE.md alongside this file for details.
