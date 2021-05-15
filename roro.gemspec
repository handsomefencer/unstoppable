
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roro/version"

Gem::Specification.new do |spec|
  spec.name          = "roro"
  spec.version       = Roro::VERSION
  spec.authors       = ["schadenfred"]
  spec.email         = ["fred.schoeneman@gmail.com"]

  spec.summary       = %q{Containerization framwork for Ruby on Rails applications.}
  spec.description   = %q{Roro is a containerization and continuous integration framework for Ruby on Rails applications. Like Rails, it favors convention over configuration "...for programmer happiness and sustainable productivity."}
  spec.homepage      = "https://github.com/schadenfred/roro"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/schadenfred/roro"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables << 'roro'
  spec.require_paths = ['lib']
  spec.add_dependency 'gem-release', '~> 2.1'
  spec.add_dependency 'rake', '~> 13.0', '>= 13.0.1'
  spec.add_dependency 'sshkit', '~> 1.21'
  spec.add_dependency 'thor', '~> 1.0', '>= 1.0.1'
  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  spec.add_development_dependency 'handsome_fencer-test', '~> 0.2.2'
  spec.add_development_dependency 'minitest-focus'
  spec.add_development_dependency 'readline'
  spec.add_development_dependency 'mocha', '~> 1.11', '>= 1.11.2'
  spec.add_development_dependency 'climate_control'

end
