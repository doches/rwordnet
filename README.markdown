# A pure Ruby interface to WordNet #

 - Works directly on the database that comes with WordNet
 - Includes WordNet database (total size: 8.1M vs 24M Ruby-Wordnet+DB)
 - No gem/native dependencies
 - Can use different WordNet installation (see examples below)

For data-intensive tasks [Ruby-WordNet](http://www.deveiate.org/projects/Ruby-WordNet/) can be faster since since it converts the WordNet database into a BerkelyDB file.

## Installation ##

```Bash
gem install rwordnet
```

## Usage ##

Finding all of the noun glosses for a given word:

```Ruby
require 'wordnet'

index = WordNet::NounIndex.instance
lemma = index.find("fruit")
puts lemma.synsets.map(&:gloss)
```

... or all of the glosses:

```Ruby
lemmas = WordNet::WordNetDB.find("fruit")
synsets = lemmas.map(&:synsets)
words = synsets.flatten
puts words.map(&:gloss)
```

Have your own WordNet database that you've marked up with extra attributes and whatnot?

```Ruby
require 'wordnet'

WordNet::WordNetDB.path = "/path/to/WordNet-3.0"
lemmas = WordNet::WordNetDB.find("fruit")
...
```

Author
======

[Trevor Fountain](http://texasexpat.net/)<br/>
trevor@texasexpat.net<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/doches/rwordnet.png)](https://travis-ci.org/doches/rwordnet)
