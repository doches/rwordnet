require 'rubygems'
require 'rake'
 
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rwordnet"
    gem.summary = %Q{A pure Ruby interface to the WordNet database}
    gem.description = %Q{A pure Ruby interface to the WordNet database}
    gem.email = "doches@gmail.com"
    gem.homepage = "http://github.com/doches/rwordnet"
    gem.authors = ["Trevor Fountain"]
    gem.files = FileList["lib/**/*","History.txt","WordNet-3.0/**/*","examples/**/*","test/**/*","README.markdown"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
 
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
 
task :test => :check_dependencies
 
task :default => :test
 
gem 'rdoc'
require 'rdoc'
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end
 
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rwordnet #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/wordnet/*.rb')
  rdoc.options += ["-SHN","-f","darkfish"]
end
