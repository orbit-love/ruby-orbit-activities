# frozen_string_literal: true

require_relative "lib/orbit_activities/version"

Gem::Specification.new do |spec|
  spec.name = "orbit_activities"
  spec.version                = OrbitActivities::VERSION
  spec.authors                = ["Orbit DevRel", "Ben Greenberg"]
  spec.email                  = ["devrel@orbit.love"]

  spec.summary                = "A helper library to build custom activities for Orbit"
  spec.description            = "This gem helps you build custom activities for Orbit workspaces using the Orbit API"
  spec.homepage               = "https://github.com/orbit-love/ruby-orbit-activities"
  spec.license                = "MIT"
  spec.required_ruby_version  = Gem::Requirement.new(">= 2.7.2")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/orbit-love/ruby-orbit-activities/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir                 = "bin"
  spec.executables            = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths          = ["lib"]

  spec.add_dependency "http", "~> 4.4"
  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "rake", "~> 13.0"
  spec.add_dependency "zeitwerk", "~> 2.4"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "webmock", "~> 3.12"
end
