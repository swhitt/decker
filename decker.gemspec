# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'decker/version'

Gem::Specification.new do |spec|
  spec.name          = 'decker'
  spec.version       = Decker::VERSION
  spec.authors       = ['Steve Whittaker']
  spec.email         = ['swhitt@gmail.com']

  spec.summary       = 'Represent and compare simple poker hands.'
  spec.description   = "A solution to Project Euler's Problem 54 - Poker Hands"
  spec.homepage      = 'https://projecteuler.net/problem=54'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
