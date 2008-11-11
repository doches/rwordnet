Gem::Specification.new do |s|
  s.name     = "rwordnet"
  s.version  = "0.1.0"
  s.date     = "10 Nov 2008"
  s.summary  = "A pure Ruby interface to WordNet"
  s.email    = "doches@gmail.com"
  s.homepage = "http://github.com/doches/rwordnet"
  s.description = "rWordNet is a pure Ruby library for reading WordNet databases with ease."
  s.has_rdoc = true
  s.authors  = "Trevor Fountain"
  s.files    = ["History.txt", 
    "README.markdown", 
    "rwordnet.gemspec", 
    "lib/wordnet.rb",
    "lib/wordnet/index.rb",
    "lib/wordnet/lemma.rb",
    "lib/wordnet/pointer.rb",
    "lib/wordnet/pointers.rb",
    "lib/wordnet/pos.rb",
    "lib/wordnet/synset.rb",
    "lib/wordnet/wordnetdb.rb",
    "WordNet-3.0/AUTHORS",
    "WordNet-3.0/COPYING",
    "WordNet-3.0/LICENSE",
    "WordNet-3.0/README",
    "WordNet-3.0/dict/data.adj",
    "WordNet-3.0/dict/data.adv",
    "WordNet-3.0/dict/data.n",
    "WordNet-3.0/dict/data.v",
    "WordNet-3.0/dict/index.adj",
    "WordNet-3.0/dict/index.adv",
    "WordNet-3.0/dict/index.n",
    "WordNet-3.0/dict/index.v",
    "examples/dictionary.rb",
    "examples/full_hypernym.rb"]
  s.test_files = ["test/test_helper.rb", 
    "test/unit/index_test.rb",
    "test/unit/synset_test.rb",
    "test/unit/wordnetdb_test.rb"]
end

