$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "os"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "mocha/minitest"
require "thor_helper"
require "byebug"

include TestHelper::Files::Assertions

module RoroSystemStubs 
  # Given { IO.stubs(:popen).returns([])}  
  # Given { stub_system_calls }
  
  def stub_system_calls
    IO.stubs(:popen).returns([])
    Roro::CLI.any_instance.stubs(:startup_commands)
    Roro::CLI.any_instance.stubs(:remove_roro_artifacts)
    Roro::CLI.any_instance.stubs(:confirm_dependencies)
    Roro::CLI.any_instance.stubs(:confirm_directory_not_empty)
    Roro::CLI.any_instance.stubs(:confirm_directory_empty)
  end
end

include RoroSystemStubs

Minitest.after_run do
  Dir.chdir(ENV.fetch("PWD"))
  # FileUtils.rm_rf 'tmp/.'
end
