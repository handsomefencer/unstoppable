require "test_helper"

describe Roro::CLI do
  
  Given { prepare_destination 'greenfield/greenfield' }  
  Given(:cli) { Roro::CLI.new }
  
  describe 'calls rollon methods' do 
    
    Given { cli.expects(:configure_for_rollon) }
    Given { cli.expects(:manifest_actions) }
    Given { cli.expects(:manifest_intentions) }
    Given { cli.expects(:congratulations) }
    Given { cli.expects(:startup_commands) }
    Given { cli.rollon }
    
    Then  { assert cli }
  end
  
  describe 'rollon methods' do 
    
    describe '.configure_for_rollon' do 
      
      Given { Roro::Configuration.expects(:new).with({ story: :rails} ) }
      Given { cli.configure_for_rollon({story: :rails}) }
      
      Then  { cli }  
    end
  end
end