# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "browser_shooter/version"

Gem::Specification.new do |s|
  s.name        = "browser_shooter"
  s.version     = BrowserShooter::VERSION
  s.authors     = ["Fernando Guillen"]
  s.email       = ["fguillen.mail@gmail.com"]
  s.homepage    = "https://github.com/fguillen/BrowserShooter"
  s.summary     = "Selenium RC wraper to create browser screenshots"
  s.description = "Selenium RC wraper to create browser screenshots"

  s.rubyforge_project = "browser_shooter"

  s.add_development_dependency "bundler",   ">= 1.0.0.rc.6"
  s.add_development_dependency "rake",      "0.9.2.2"
  s.add_development_dependency "mocha"

  s.add_dependency "selenium-webdriver"
  s.add_dependency "selenium"
  s.add_dependency "selenium-client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
