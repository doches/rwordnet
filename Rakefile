require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :examples do
  Dir["examples/*"].each do |e|
    command = "ruby -Ilib #{e} fruit"
    result = `#{command}`
    raise "FAILED: #{command}: #{result}" unless $?.success?
  end
end

task :default => [:test, :examples]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rwordnet #{WordNet::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/rwordnet/*.rb')
  rdoc.options += ["-SHN","-f","darkfish"]
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end
