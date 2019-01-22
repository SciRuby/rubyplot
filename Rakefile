require "bundler/gem_tasks"
require "rake"
require 'rake/extensiontask'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new

desc 'Default: run unit specs.'
task :default => %w[spec rubocop]

gemspec = eval(IO.read('rubyplot.gemspec'))

ext_name = 'grruby'
Rake::ExtensionTask.new(ext_name, gemspec) do |ext|
  ext.ext_dir = "ext/#{ext_name}"
  ext.source_pattern = '**/*.{c,h}'
end

def run(*cmd)
  sh(cmd.join(' '))
end

task :pry do |_task|
  cmd = ['pry', "-r './lib/rubyplot.rb' "]
  run(*cmd)
end
