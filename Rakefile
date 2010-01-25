require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "yard-pygments"
    gem.summary = %Q{Pygments-based syntax highlighting for YARD.}
    gem.description = <<DESC
A plugin for the YARD documentation system that adds syntax highlighting
for a wide variety of languages using the Pygments highlighter.
DESC
    gem.email = "nex342@gmail.com"
    gem.homepage = "http://github.com/nex3/yard-pygments"
    gem.authors = ["Nathan Weizenbaum"]
    gem.add_dependency('yard', '~> 0.5.3')
    gem.add_dependency('rb-pygments', '= 0.1.0')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
