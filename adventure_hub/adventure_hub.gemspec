# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adventure_hub/version"

Gem::Specification.new do |s|
  s.name        = "adventure_hub"
  s.version     = AdventureHub::VERSION
  s.authors     = ["Scott Fleckenstein"]
  s.email       = ["nullstyle@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "adventure_hub"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "multi_json"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "celluloid"
end
