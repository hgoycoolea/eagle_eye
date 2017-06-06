# coding: utf-8

require File.expand_path('../lib/eagle_eye/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "eagle_eye"
  gem.version       = EagleEye::VERSION
  gem.authors       = ["Hector Goycoolea"]
  gem.email         = ["hector@goycooleainc.com"]

  gem.summary       = %q{Crawler for Saudi websites.}
  gem.homepage      = "http://goycooleainc.com"
  gem.license       = "MIT"

  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.14"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "minitest", "~> 5.0"
  gem.add_development_dependency "nokogiri"
  gem.add_development_dependency "mechanize"
  gem.add_development_dependency "mysql2"
  gem.add_development_dependency "waitutil"
  gem.add_development_dependency "colorize"
  gem.add_development_dependency "alexa_rubykit"
end
