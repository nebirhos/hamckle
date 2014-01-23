# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamckle_frester/version'

Gem::Specification.new do |spec|
  spec.name          = "hamckle_frester"
  spec.version       = HamckleFrester::VERSION
  spec.authors       = ["Francesco Disperati"]
  spec.email         = ["me@nebirhos.com"]
  spec.summary       = %q{Import your Project Hamster time logs into LetsFreckle.com}
  spec.homepage      = "https://github.com/nebirhos/hamckle_frester"
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
end
