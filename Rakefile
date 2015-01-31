require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rwordnet #{WordNet::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/wordnet/*.rb')
  rdoc.options += ["-SHN","-f","darkfish"]
end
