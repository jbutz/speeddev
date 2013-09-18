# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speeddev/version'

Gem::Specification.new do |spec|
  spec.name          = "speeddev"
  spec.version       = Speeddev::VERSION
  spec.authors       = ["Jason Butz"]
  spec.description   = %q{Don't let different tools for different things slow you down. One tool to rule them all.}
  spec.summary       = %q{One tool to rule them all.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("sass")
  spec.add_dependency("less")
  spec.add_dependency("compass")
  spec.add_dependency("stylus")
  spec.add_dependency("rdiscount")
  spec.add_dependency("json","~> 1.7.7")
  spec.add_dependency("therubyracer")

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"


end
