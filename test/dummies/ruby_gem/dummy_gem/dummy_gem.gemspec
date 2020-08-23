# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'dummy_gem/version'

Gem::Specification.new do |s|
  s.name          = 'dummy_gem'
  s.version       = DummyGem::VERSION
  s.authors       = ['schadenfred']
  s.email         = ['fred.schoeneman@gmail.com']
  s.homepage      = 'https://github.com/schadenfred/dummy_gem'
  s.licenses      = ['MIT']
  s.summary       = '[summary]'
  s.description   = '[description]'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
