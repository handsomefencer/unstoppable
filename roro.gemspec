
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roro/version"

Gem::Specification.new do |spec|
  spec.name          = "roro"
  spec.version       = Roro::VERSION
  spec.authors       = ["schadenfred"]
  spec.email         = ["fred.schoeneman@gmail.com"]

  spec.summary       = %q{Dockerize your Rails app, set it up for CI, roll it onto your image repository, and then roll it off to your staging and production hosts.}
  spec.description   = %q{You've finished development of your Rails app and now it's time to deploy. You're looking at Docker and Docker Compose, and at difference CI/CD services, at integrating with Docker Hub, and at trying to figure out how to deploy safely. There are lots of things that can go wrong. You've found some of them, and they haven't been much fun to fix. This gem and the companion tutorial may prove helpful.}
  spec.homepage      = "https://github.com/schadenfred/handsome_fencer-roro"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/schadenfred/handsome_fencer-roro"

  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "handsome_fencer-test"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rr"
  spec.add_development_dependency "minitest-stub_any_instance"
end
