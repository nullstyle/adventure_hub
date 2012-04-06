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
  s.add_runtime_dependency "multi_json"
  s.add_runtime_dependency "json", ">= 1.6.5"

  s.add_runtime_dependency "activesupport", ">= 3.1.0"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "celluloid"
  s.add_runtime_dependency "ruby-terminfo"
  s.add_runtime_dependency "sequel"
  s.add_runtime_dependency "ripl"
  s.add_runtime_dependency "popen4"
  s.add_runtime_dependency "sinatra"
  s.add_runtime_dependency "thin"
  s.add_runtime_dependency "nokogiri"
  
  s.add_runtime_dependency "data_mapper",       ">= 1.2.0"
  s.add_runtime_dependency "dm-sqlite-adapter", ">= 1.2.0"
  s.add_runtime_dependency "dm-is-list", ">= 1.2.0"
  s.add_runtime_dependency "do_sqlite3", ">= 0.10.8"

  s.add_development_dependency "rspec", "~> 2.9.0"
  s.add_development_dependency 'rake'
end
