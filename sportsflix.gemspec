# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sportsflix/version'

Gem::Specification.new do |spec|
  spec.name        = 'sportsflix'
  spec.version     = Sportsflix::VERSION
  spec.authors     = ['Rodrigo Fernandes']
  spec.email       = ['rodrigo.fernandes@tecnico.ulisboa.pt']
  spec.summary     = %q{Watch the best sports stream in HD from the command line}
  spec.description = %q{
    Watch the best sports stream in HD from the command line.
    Using arenavision streams.
  }
  spec.homepage    = 'https://github.com/rtfpessoa/sportsflix'
  spec.license     = 'GPL-3.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = 'sflix'
  spec.require_paths = ['lib']

  # Development
  spec.add_development_dependency 'bundler', ['~> 1.14']
  spec.add_development_dependency 'rake', ['~> 10.0']
  spec.add_development_dependency 'rspec', ['~> 3.0']
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codacy-coverage'

  # Linters
  spec.add_development_dependency 'rubocop', ['~> 0.47.1']
  spec.add_development_dependency 'rubocop-rspec', ['~> 1.10']

  # Runtime
  spec.add_runtime_dependency 'thor', ['~> 0.19.4']
  spec.add_runtime_dependency 'oga', ['~> 2.8']
  spec.add_runtime_dependency 'execjs-fastnode', ['~> 0.2.0']
end
