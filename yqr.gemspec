# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yqr/version'

Gem::Specification.new do |spec|
  spec.name          = "yqr"
  spec.version       = Yqr::VERSION
  spec.authors       = ["metalels"]
  spec.email         = ["metalels86@gmail.com"]

  spec.summary       = %q{YAML Query is written in ruby.}
  spec.description   = %q{YAML Query is written in ruby.}
  spec.homepage      = "https://github.com/metalels/yqr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
