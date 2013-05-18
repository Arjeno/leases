# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'leases/version'

Gem::Specification.new do |gem|
  gem.name          = 'leases'
  gem.version       = Leases::VERSION
  gem.authors       = ['Arjen Oosterkamp']
  gem.email         = ['mail@arjen.me']
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '>= 1.0.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '>= 2.3'
  gem.add_development_dependency 'rspec-rails', '~> 2.0'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'with_model'

  gem.add_dependency 'rails', '>= 3.0'
  gem.add_dependency 'apartment', '>= 0.20'
end
