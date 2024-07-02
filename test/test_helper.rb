# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
ENV['RORO_ENV'] ||= 'test'

require 'debug'
require 'fileutils'
require 'minitest/autorun'
require 'minitest/given'
require 'minitest/hooks/default'
require 'minitest/spec'
require 'minitest/focus'
require 'minitest/reporters'
require 'minitest/pride'
require 'mocha/minitest'
require 'climate_control'
require 'roro'

include Roro::Configurators
include Roro::Crypto

Dir["#{Dir.pwd}/test/test_helpers/**/*.rb"].each { |f| require f }

reporters = %w[Progress]
reporters << "JUnit" if ENV['CI']
reporters.reject! { |r| r.nil? }
reporters.map! { |r| "Minitest::Reporters::#{r.to_s}Reporter".constantize.new }

Minitest::Reporters.use!(reporters)

include Roro::TestHelpers::FileAssertionsTestHelper

module Roro
  module TestHelpers
    include FilesTestHelper
    include FileAssertionsTestHelper
    include StackReflectorTestHelper
    include StackTestHelper
    include ConfiguratorTestHelper
  end
end

include Roro::TestHelpers
