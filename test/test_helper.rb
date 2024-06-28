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

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new, Minitest::Reporters::JUnitReporter.new]

# include Roro::TestHelpers::RakeTaskTestHelper
# include Roro::TestHelpers::ReflectionHelper
# include Roro::TestHelpers::AdventureHelper
# include Roro::TestHelpers::ConfiguratorTestHelper


# # frozen_string_literal: true
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
