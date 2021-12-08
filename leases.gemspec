# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'leases/version'

Gem::Specification.new do |gem|
  gem.name          = 'leases'
  gem.version       = Leases::VERSION
  gem.authors       = ['Arjen Oosterkamp']
  gem.email         = ['mail@arjen.me']
  gem.description   = %q{Database multi-tenancy for Rails.}
  gem.summary       = %q{Database multi-tenancy for Rails.}
  gem.homepage      = 'https://github.com/Arjeno/leases'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler',     '>= 1.3.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec',       '~> 2.11'
  gem.add_development_dependency 'rspec-rails', '~> 2.11'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'with_model'
  gem.add_development_dependency 'test-unit', '~> 3.0'

  gem.add_dependency 'ros-apartment', '>= 1.0.0'
end
