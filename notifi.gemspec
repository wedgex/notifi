# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'notifi/version'

Gem::Specification.new do |spec|
  spec.name          = "notifi"
  spec.version       = Notifi::VERSION
  spec.authors       = ["Hunter Haydel"]
  spec.email         = ["haydh530@gmail.com"]
  spec.description   = "Simple frame for creating subsciption and notificaton records"
  spec.summary       = "Simple frame for creating subsciption and notificaton records"
  spec.homepage      = "http://www.github.com/wedgex/notifi"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", "~> 3.1.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "database_cleaner"
end
