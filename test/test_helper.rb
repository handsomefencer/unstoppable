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
  
  def stubs_system_calls
    Roro::CLI.any_instance.stubs(:system) 
  end
  
  def stubs_startup_commands
    Roro::CLI.any_instance.stubs(:startup_commands) 
  end
  
  def stubs_rollon 
    Roro::CLI.any_instance.stubs(:rollon) 
  end

  def stubs_dependency_responses 
    Roro::Configurator.any_instance.stubs(:screen_target_directory)
  end
  
  def greenfield_rails_test_base 
    prepare_destination 'greenfield/greenfield'
    stubs_rollon
    stubs_system_calls
    stubs_startup_commands
    stubs_dependency_responses
    @cli = Roro::CLI.new 
  end
end

include RoroSystemStubs
