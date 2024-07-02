lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake'
require 'roro/version'

Gem::Specification.new do |spec|
  spec.name          = 'roro'
  spec.version       = Roro::VERSION
  spec.authors       = ['schadenfred']
  spec.email         = ['fred.schoeneman@gmail.com']

  spec.summary       = 'Containerization framework for Ruby on Rails applications.'
  spec.description   = 'Roro is a containerization and continuous integration framework for Ruby on Rails applications. Like Rails, it favors convention over configuration "...for programmer happiness and sustainable productivity."'
  spec.homepage      = 'https://github.com/schadenfred/roro'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/schadenfred/roro'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = FileList['lib/**/*',
                          'bin/*',
                          '[A-Z]*'].to_a

  # spec.files = Dir.chdir(File.expand_path(__dir__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end

  spec.executables << 'roro'
  spec.require_paths = ['lib']
  spec.add_dependency 'gem-release', '~> 2.1'
  spec.add_dependency 'deep_merge', '~> 1.2', '>= 1.2.2'

  spec.add_dependency 'base64', '~> 0.2.0'
  spec.add_dependency 'os', '~> 1.1', '>= 1.1.4'
  spec.add_dependency 'rake', '~> 13.2', '>= 13.2.1'
  spec.add_dependency 'sshkit', '~> 1.22'
  spec.add_dependency 'thor', '~> 1.3', '>= 1.3.1'
  spec.add_dependency 'activesupport', '~> 7.1', '>= 7.1.3.2'
  spec.add_dependency 'rb-readline', '~> 0.5.5'
  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'climate_control'
  spec.add_development_dependency 'debug', '~> 1.9', '>= 1.9.1'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest-focus'
  spec.add_development_dependency 'minitest-given'
  spec.add_development_dependency 'minitest-hooks'
  spec.add_development_dependency 'minitest-profile'
  spec.add_development_dependency 'mocha', '~> 1.11', '>= 1.11.2'
end
