# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamckle_frester/version'

Gem::Specification.new do |spec|
  spec.name          = "hamckle_frester"
  spec.version       = HamckleFrester::VERSION
  spec.authors       = ["nebirhos"]
  spec.email         = ["me@nebirhos.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sequel", "~> 4.6.0"
  spec.add_runtime_dependency "sqlite3", "~> 1.3.8"
  spec.add_runtime_dependency 'thor', '~> 0.18'
  spec.add_runtime_dependency 'hashie', '~> 1.1.0'
  # letsfreckle-client dependecies
  spec.add_runtime_dependency "builder", "~> 3.1.4"
  spec.add_runtime_dependency "activesupport", "~> 4.0"
  spec.add_runtime_dependency 'letsfreckle-client', '~> 0.2'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
