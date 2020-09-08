
module TestHelper
  module Mocks
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
  end 
end