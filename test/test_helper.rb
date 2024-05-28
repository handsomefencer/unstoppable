# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
ENV['RORO_ENV'] ||= 'test'

require 'debug'
require 'fileutils'
require 'minitest/autorun'
require 'minitest/given'
require 'minitest/hooks/default'
require 'minitest/pride'
require 'minitest/spec'
require 'minitest/focus'
require 'mocha/minitest'
require 'climate_control'
require 'roro'

include Roro::Configurators
include Roro::Crypto

Dir["#{Dir.pwd}/test/test_helpers/**/*.rb"].each { |f| require f }

include Roro::TestHelpers::FilesTestHelper
include Roro::TestHelpers
# include Roro::TestHelpers::RakeTaskHelper
# include Roro::TestHelpers::ReflectionHelper
# include Roro::TestHelpers::AdventureHelper
# include Roro::TestHelpers::ConfiguratorHelper


# # frozen_string_literal: true

module Roro
  module TestHelpers
    include FilesTestHelper
    include StackReflectorTestHelper
    include ConfiguratorHelper
  end
end
