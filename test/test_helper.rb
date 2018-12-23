$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "minitest/stub_any_instance"
require "mocha"
require "rr"

require "thor_helper"
include TestHelper::Files::Assertions
