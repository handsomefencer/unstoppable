# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'byebug'
require 'fileutils'
require 'minitest/autorun'
require 'minitest/given'
require 'minitest/focus'
require 'minitest/hooks/default'
require 'minitest/pride'
require 'minitest/spec'
require 'mocha/minitest'
require 'climate_control'

require 'roro'

Dir.glob("#{Dir.pwd}/test/helpers/**/*.rb").sort.each { |h| require h }
module Roro
  module Test
    module Mocks; end

    module Helpers
      module Stories; end
    end
  end
end

# include TestHelper::Stories::Rails
include Roro::Test::Helpers::Mocks
include Roro::Test::Helpers::FilesHelper
include Roro::Test::Helpers::Stories::Rails
include Roro::Test::Helpers::Stories::WorkBench
