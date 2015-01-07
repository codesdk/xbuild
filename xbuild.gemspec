# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xbuild/version'

Gem::Specification.new do |spec|
  spec.name          = "xbuild"
  spec.version       = Xbuild::VERSION
  spec.authors       = ["Guido Marucci Blas"]
  spec.email         = ["guidomb@gmail.com"]
  spec.summary       = %q{A wrapper over xcodebuild and xctool }
  spec.description   = %q{XBuild is a thin wrapper on top of xcodebuild and xctool that allows you to configure your favorite iOS & Mac build tool for your project.}
  spec.homepage      = "https://github.com/guidomb/xbuild"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "byebug", "~> 3.5.1"
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.add_dependency "clamp", "~>0.6.3"
end
