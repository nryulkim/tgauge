# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "tgauge"
  spec.version       = TGauge::VERSION
  spec.authors       = ["Nam Kim"]
  spec.email         = ["nryulkim@gmail.com"]

  spec.summary       = %q{Simple Ruby ORM and MVC}
  spec.description   = %q{Allows you to build a simple webapp}
  spec.homepage      = "https://github.com/nryulkim/tgauge"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["tgauge"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'pg', '~> 0.18'
  spec.add_runtime_dependency 'pry', '~> 0.10.3'
  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.5.1'
  spec.add_runtime_dependency 'rack', '~> 1.6', '>=1.6.4'
  spec.add_runtime_dependency 'fileutils', '~> 0.7'
end
