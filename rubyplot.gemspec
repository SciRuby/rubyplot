# coding: utf-8
$:.unshift File.expand_path("../lib", __FILE__)

require 'rubyplot/version.rb'

Rubyplot::DESCRIPTION = <<MSG
An advanced plotting library for Ruby.
MSG

Gem::Specification.new do |spec|
  spec.name          = 'rubyplot'
  spec.version       = Rubyplot::VERSION
  spec.authors       = ['Arafat Khan', 'Pranav Garg', 'John Woods', 'Pjotr Prins', 'Sameer Deshmukh']
  spec.email         = ['sameer.deshmukh93@gmail.com'] # add other author ids 
  spec.summary       = %q{An advaced plotting library for Ruby.}
  spec.description   = Rubyplot::DESCRIPTION
  spec.homepage      = "http://github.com/sciruby/rubyplot"
  spec.license       = 'BSD-3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    = ['ext/grruby/extconf.rb']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'rmagick',  '>= 2.13.4'
end
