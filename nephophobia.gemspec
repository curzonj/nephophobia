# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nephophobia/version"

Gem::Specification.new do |s|
  s.name        = "nephophobia"
  s.version     = Nephophobia::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "nephophobia"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "hugs"

  s.add_development_dependency "webmock"
  s.add_development_dependency "minitest"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "rake"
  s.add_development_dependency "timecop"
  s.add_development_dependency "vcr", "1.5.0"
end
