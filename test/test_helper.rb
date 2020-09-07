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
  def stub_system_calls
    cli = Roro::CLI.any_instance
    cli.stubs(:system) 
    cli.stubs(:startup_commands) 
  end
  
  def stub_dependency_responses 
    Roro::Configurator.any_instance.stubs(:screen_target_directory)
  end
end

include RoroSystemStubs
