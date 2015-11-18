require 'rake'
require './lib/wordnet/version'

Gem::Specification.new "rwordnet", WordNet::VERSION do |s|
  s.summary = "A pure Ruby interface to the WordNet database"
  s.authors = ["Trevor Fountain", "Wolfram Sieber", "Michael Grosser"]
  s.email = "trevor@texasexpat.net"
  s.homepage = "https://github.com/doches/rwordnet"
  s.license = "MIT"
  s.files = FileList["lib/**/*","History.txt","WordNet-3.0/**/*","examples/**/*","test/**/*","morphy/**/*", "test/**/*", "README.markdown"]
  s.required_ruby_version = '>= 2.0.0'
end
