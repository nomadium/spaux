# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spaux/version'

Gem::Specification.new do |spec|
  spec.name          = "spaux"
  spec.version       = Spaux::VERSION
  spec.authors       = ["Miguel Landaeta"]
  spec.email         = ["miguel@miguel.cc"]
  spec.summary       = %q{Spaux automation tasks}
  spec.homepage      = "https://api.qirtaiba.org/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "chef", '= 12.0.0.rc.0'
  spec.add_dependency "octokit"
  spec.add_dependency "net-ssh"
  spec.add_dependency 'chef-provisioning', '~> 0.16.1'
  spec.add_dependency 'chef-metal-fog'
  spec.add_dependency 'chef-vault'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
