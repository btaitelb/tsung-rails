# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tsung/rails/version"

Gem::Specification.new do |s|
  s.name        = "tsung-rails"
  s.version     = Tsung::Rails::VERSION
  s.authors     = ["Ben Taitelbaum"]
  s.email       = ["ben@coshx.com"]
  s.homepage    = "https://github.com/coshx/tsung-rails"
  s.summary     = %q{Tsung load tester for rails}
  s.description = %q{Integrates tsung recording and playback with rails}

  s.rubyforge_project = "tsung-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'rspec'
#  s.add_runtime_dependency 'rails'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'activesupport'
end
