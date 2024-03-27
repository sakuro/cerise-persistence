# frozen_string_literal: true

require_relative "lib/cerise/persistence/version"

Gem::Specification.new do |spec|
  spec.name = "cerise-persistence"
  spec.version = Cerise::Persistence::VERSION
  spec.authors = ["OZAWA Sakuro"]
  spec.email = ["10973+sakuro@users.noreply.github.com"]

  spec.summary = "Persistence support"
  spec.description = "Simple persistence support for Hanami applications"
  spec.homepage = "https://github.com/sakuro/cerise-persistence"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}.git"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "hanami", "~> 2.1"
  spec.add_dependency "rom", "~> 5.3"
  spec.add_dependency "rom-repository", "~> 5.3"
  spec.add_dependency "zeitwerk", "~> 2.6"
end
