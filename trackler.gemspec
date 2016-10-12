# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trackler/version'

Gem::Specification.new do |spec|
  spec.name          = "trackler"
  spec.version       = Trackler::VERSION
  spec.authors       = ["Katrina Owen"]
  spec.email         = ["katrina.owen@gmail.com"]

  spec.summary       = %q{The Exercism exercises data}
  spec.description   = %q{All of the data necessary to construct exercises in any of the Exercism tracks. This includes the shared metadata.}
  spec.homepage      = "http://exercism.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test)/})
  } + Dir.glob("common/**/*", File::FNM_DOTMATCH) + Dir.glob("tracks/**/*", File::FNM_DOTMATCH)
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip", "~> 1.1"
  spec.add_dependency "org-ruby", "~> 0.9.0"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov", "~> 0.12.0"
end
