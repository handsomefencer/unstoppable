$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "byebug"
require "fileutils"
require "minitest/autorun"
require "minitest/given"
require "minitest/focus"
require "minitest/pride"
require "minitest/spec"
require "mocha/minitest"
require "climate_control"

require "roro"

# include TestHelper::Stories::Rails
Dir.glob(Dir.pwd + '/test/helpers/**/*.rb').each {|h| require h}
module Roro
  module Test 
    module Mocks    ; end
    module Helpers
      module Stories ; end
    end
  end
end

include Roro::Test::Helpers::Mocks
include Roro::Test::Helpers::FilesHelper
include Roro::Test::Helpers::Stories::Rails
include Roro::Test::Helpers::Stories::WorkBench