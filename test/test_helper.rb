$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "thor_helper"

require "generators/shared_expectations"

# include Roro::Test::SharedExpectations
include TestHelper::Files::Assertions
Minitest.after_run do
# puts Dir.pwd.upcase
Dir.chdir('.')

  # src = 'dummy'
  # dest = '.'
  # FileUtils.cp_r( src, dest )
end
