# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name         = 'opal-observer'
  s.version      = '0.0.1'
  s.author       = 'Adam Beynon'
  s.email        = 'adam.beynon@gmail.com'
  s.homepage     = 'http://opalrb.org'
  s.summary      = 'KVO style observers for Opal'
  s.description  = 'KVO style observers for Opal'

  s.files          = `git ls-files`.split("\n")
  s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths  = ['lib']

  s.add_runtime_dependency 'opal', '>= 0.3.42'
end
