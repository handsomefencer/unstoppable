$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "mocha/minitest"
require "thor_helper"
require "byebug"

include TestHelper::Files::Assertions

module RoroSystemStubs 
  # Given { IO.stubs(:popen).returns([])}  
  def stub_system_calls
    cli = Roro::CLI.any_instance
    cli.stubs(:system) 
    cli.stubs(:startup_commands) 
  end
end

include RoroSystemStubs

# Minitest.after_run do
#   Dir.chdir(ENV.fetch("PWD"))
# end
