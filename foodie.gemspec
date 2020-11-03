require_relative 'lib/foodie/version'

Gem::Specification.new do |spec|
  spec.name          = "foodie"
  spec.version       = Foodie::VERSION
  spec.authors       = ["John Ratana"]
  spec.email         = ["jratana1@gmail.com"]

  spec.summary       = "cats and dogs"
  spec.description   = "cats and dogs"
  spec.homepage      = "https://github.com/jratana1/foodie.git"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = 'http://mygemserver.com'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jratana1/foodie.git"
  spec.metadata["changelog_uri"] = "https://github.com/jratana1/foodie.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
