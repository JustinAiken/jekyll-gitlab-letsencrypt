lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/gitlab/letsencrypt/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll-gitlab-letsencrypt"
  spec.version       = Jekyll::Gitlab::Letsencrypt::VERSION
  spec.authors       = ["Justin Aiken"]
  spec.email         = ["60tonangel@gmail.com"]

  spec.summary       = %q{Automate letsencrypt renewals for gitlab pages.}
  spec.description   = %q{Automate letsencrypt renewals for gitlab pages.}
  spec.homepage      = "https://github.com/JustinAiken/jekyll-gitlab-letsencrypt"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match %r{^(spec)/} }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",    ">= 1.13"
  spec.add_development_dependency "rake",       ">= 10.0"
  spec.add_development_dependency "rspec",      "~> 3.0"
  spec.add_development_dependency "jekyll",     ">= 3.0"
  spec.add_development_dependency "vcr",        "~> 3.0.3"
  spec.add_development_dependency "coveralls"

  spec.add_dependency "activesupport", ">= 3.0.0"
  spec.add_dependency "acme-client",   "~> 0.5.0"
end
