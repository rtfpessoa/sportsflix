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

  spec.required_ruby_version = '>= 2.3.7'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['sportsflix', 'sflix']
  spec.require_paths = ['lib']

  # Development
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', ['~> 3.8']
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codacy-coverage'

  # Linters
  spec.add_development_dependency 'rubocop', ['~> 0.65.0']
  spec.add_development_dependency 'rubocop-rspec', ['~> 1.32']

  # Runtime
  spec.add_runtime_dependency 'thor', '>= 0.20', '< 2.0'
  spec.add_runtime_dependency 'oga', '>= 2.15', '< 4.0'
  spec.add_runtime_dependency 'therubyracer', ['~> 0.12']
  spec.add_runtime_dependency 'execjs-fastnode', ['~> 0.2']
end
