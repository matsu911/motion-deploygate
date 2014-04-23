# -*- encoding: utf-8 -*-
VERSION = "1.0"

Gem::Specification.new do |spec|
  spec.name          = "motion-deploygate"
  spec.version       = VERSION
  spec.authors       = [""]
  spec.email         = ["watson1978@gmail.com"]
  spec.description   = %q{DeployGate integration for RubyMotion projects}
  spec.summary       = %q{DeployGate integration for RubyMotion projects}
  spec.homepage      = ""
  spec.license       = ""

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
