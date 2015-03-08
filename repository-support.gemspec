
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'repository/support/version'

Gem::Specification.new do |spec|
  spec.name          = 'repository-support'
  spec.version       = Repository::Support::VERSION
  spec.authors       = ['Jeff Dickey']
  spec.email         = ['jdickey@seven-sigma.com']
  spec.summary       = %q{Support classes for Repository::Base and subclasses.}
  spec.description   = %q{Support classes for Repository::Base and subclasses.}
  spec.homepage      = 'https://github.com/jdickey/repository-support'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'activemodel', '~> 4.2', '>= 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.28', '>= 0.28.0'
  spec.add_development_dependency 'simplecov', '~> 0.9', '>= 0.9.1'
  spec.add_development_dependency 'awesome_print', '~> 0'
#  spec.add_development_dependency 'pry-byebug'
end
