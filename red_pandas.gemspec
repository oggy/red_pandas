# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'red_pandas/version'

Gem::Specification.new do |gem|
  gem.name          = 'red_pandas'
  gem.version       = RedPandas::VERSION
  gem.authors       = ['George Ogata']
  gem.email         = ['george.ogata@gmail.com']
  gem.description   = "TODO: Write a gem description"
  gem.summary       = "TODO: Write a gem summary"
  gem.homepage      = ''

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.add_development_dependency 'ritual', '~> 0.4.1'
end
