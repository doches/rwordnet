require 'bundler/setup'
require 'benchmark'
$LOAD_PATH.unshift Bundler.root.join("lib")
require "wordnet"

initial = Benchmark.realtime do
  WordNet::Lemma.find('fruit', :noun)
end

puts "Time to initial word #{initial}"

lookup = Benchmark.realtime do
  1000.times { WordNet::Lemma.find('fruit', :noun) }
end

puts "Time for 1k lookups #{lookup}"
