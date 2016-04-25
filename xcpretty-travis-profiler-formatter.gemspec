# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "xcpretty-travis-profiler-formatter"
  spec.version       = "0.0.2"
  spec.authors       = ["Lars Lockefeer", "Delisa Mason", "Daniel Miedema"]
  spec.email         = ["lars.lockefeer@teampicnic.com", "iskanamagus@gmail.com", "daniel@dmiedema.com"]
  spec.description   =
  %q{
  A combination of https://github.com/kattrali/xcpretty-travis-formatter
  and https://github.com/larslockefeer/xcpretty-profiler-formatter
  so that compilation times are shown and its formatted for Travis.
  }
  spec.summary       = %q{xcpretty formatter that profiles build times for Xcode projects with travis supported output}
  spec.homepage      = "https://github.com/dmiedema/xcpretty-travis-profiler-formatter"
  spec.license       = "MIT"
  spec.required_ruby_version = "~> 2.0"
  spec.files         = [
  	"README.md",
  	"LICENSE",
  	"lib/travis_profiler_formatter.rb",
  	"bin/xcpretty-travis-profiler-formatter"]
  spec.executables   = ["xcpretty-travis-profiler-formatter"]
  spec.require_paths = ["lib"]
  spec.add_dependency "xcpretty", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.3"
end
