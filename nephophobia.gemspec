# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nephophobia/version"

Gem::Specification.new do |s|
  s.name        = "nephophobia"
  s.version     = Nephophobia::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Dewey", "Josh Kleinpeter"]
  s.email       = ["jdewey@attinteractive.com", "jkleinpeter@attinteractive.com"]
  s.homepage    = ""
  s.summary     = %q{Bindings to EC2/OpenStack}
  s.description = %q{This gem is a simple binding to the EC2 API. It has specific extensions to allow extra functionality provided by OpenStack.}

  s.rubyforge_project = "nephophobia"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "hugs", "~> 2.6.0"

  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "minitest", "~> 2.0.2"
  s.add_development_dependency "nokogiri", "~> 1.4.4"
  s.add_development_dependency "rake", "~> 0.8.7"
  s.add_development_dependency "vcr", "1.5.0"
end
