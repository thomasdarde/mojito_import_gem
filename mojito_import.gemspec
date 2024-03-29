lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mojito_import/version"

Gem::Specification.new do |spec|
  spec.name = "mojito_import"
  spec.version = MojitoImport::VERSION
  spec.authors = ["Thomas Darde"]
  spec.email = ["thomas@rougecardinal.fr"]

  spec.summary = "Mojito Import, so fresh."
  spec.homepage = "https://www.mojito-import.com"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thomasdarde/mojito_import_gem"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/thomasdarde/mojito_import_gem/master/changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "rest-client", "~> 2.0"
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "guard", "~> 2.18"
  spec.add_development_dependency "rspec", "~> 3.0"
end
