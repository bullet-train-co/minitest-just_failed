# frozen_string_literal: true

require_relative "lib/minitest/just_failed/version"

Gem::Specification.new do |spec|
  spec.name = "minitest-just_failed"
  spec.version = Minitest::JustFailed::VERSION
  spec.authors = ["Andrew Culver", "Gabriel Zayas"]
  spec.email = ["andrew.culver@gmail.com", "g-zayas@hotmail.com"]

  spec.summary = "Log and rerun failed tests in Ruby on Rails with ease"
  spec.description = "Log all failed tests and rerun them with tasks such as `rails test:failed`"
  spec.homepage = "https://github.com/bullet-train-co/minitest-just_failed"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bullet-train-co/minitest-just_failed"
  spec.metadata["changelog_uri"] = "https://github.com/bullet-train-co/minitest-just_failed/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "minitest", "~> 5.0"
  spec.add_dependency "rails", "~> 7.0.0"
  spec.add_dependency "rake", "~> 13.0"
end
