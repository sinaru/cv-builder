# frozen_string_literal: true

require_relative "lib/kamisaku/version"

Gem::Specification.new do |spec|
  spec.name = "kamisaku"
  spec.version = Kamisaku::VERSION
  spec.authors = ["Sinaru Gunawardena"]
  spec.email = ["sinaru@gmail.com"]

  spec.summary = "Build a CV PDF from a yaml text file."
  spec.description = "Build a CV PDF from a yaml text file."
  spec.homepage = "https://github.com/sinaru/kamisaku"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.3"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sinaru/kamisaku"
  spec.metadata["changelog_uri"] = "https://github.com/sinaru/kamisaku/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/sinaru/kamisaku/issues?q=is%3Aissue%20state%3Aopen%20label%3Abug"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/crea  ting_gem.html
end
