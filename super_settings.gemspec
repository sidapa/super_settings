$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "super_settings/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "super_settings"
  s.version     = SuperSettings::VERSION
  s.authors     = ["Adrian Joseph F. Tumusok"]
  s.email       = ["me@adriantumusok.com"]
  s.homepage    = "TODO"
  s.summary     = "Use custom settings"
  s.description = "Allows an application to use highly customizable settings"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.9"

  s.add_development_dependency "sqlite3"
end
