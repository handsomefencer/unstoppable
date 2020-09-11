module TestHelper
  module Stories 
    module Rails
      def greenfield_rails_test_base 
        prepare_destination 'greenfield/greenfield'
        stubs_rollon
        stubs_system_calls
        stubs_startup_commands
        stubs_dependency_responses
        @cli = Roro::CLI.new 
      end
      
      def rollon_rails_test_base 
        prepare_destination 'rails/603'
        stubs_system_calls
        stubs_startup_commands
        stubs_dependency_responses
        @cli = Roro::CLI.new 
      end 
    end
  end
end