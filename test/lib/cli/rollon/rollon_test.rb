require "test_helper"

describe Roro::CLI do

  Given { rails_test_base }  
  Given(:cli) { Roro::CLI.new }
  
  describe 'calls rollon methods' do 
    
    Given { cli.expects(:manifest_actions) }
    Given { cli.expects(:manifest_intentions) }
    Given { cli.expects(:congratulations) }
    Given { cli.expects(:startup_commands) }
    
    describe '.rollon' do 
      
      Given { cli.rollon }
      
      Then  { assert cli }
    end
    
    describe '.rollon_rails' do 
      
      Given { cli.rollon_rails }
      
      Then  { assert cli }
    end
    
    describe '.rollon_rails_kubernetes' do 
      
      Given { cli.rollon_rails_kubernetes }
      
      Then  { assert cli }
    end
    
    describe '.omakase' do
       
      Given { cli.greenfield }
      
      Then  { assert cli }
    end
    
    describe '.greenfield_rails' do
       
      Given { cli.greenfield_rails }
      
      Then  { assert cli }
    end
    
    describe '.greenfield_rails_kubernetes' do
       
      Given { cli.greenfield_rails_kubernetes }
      
      Then  { assert cli }
    end
  end
end