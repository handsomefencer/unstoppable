$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "os"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "mocha/minitest"
require "thor_helper"

include TestHelper::Files::Assertions

Minitest.after_run do
  Dir.chdir(ENV.fetch("PWD"))
  FileUtils.rm_rf 'tmp/.'
end
