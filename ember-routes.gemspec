# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ember_routes/version'

Gem::Specification.new do |spec|
  spec.name          = "ember-routes"
  spec.version       = EmberRoutes::VERSION
  spec.authors       = ["Brendan Asselstine"]
  spec.email         = ["mail.asselstine@gmail.com"]

  spec.summary       = %q{Generate Ruby path helpers using a similar syntax as Ember routes.}
  spec.description   = %q{The ember-routes gem was created to facilitate easier testing with
    Capybara by providing path helpers for the Ember app.  The path helpers are described in a similar syntax to the Ember routes engine.}
  spec.homepage      = "https://github.com/asselstine/ember-routes"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
