require 'test_helper'

describe Roro::CLI do


  describe 'check dependencies' do 
    
    Given(:subject) { Roro::CLI.new }
    Given(:error) { Roro::Error }
    
    describe 'for greenfield story' do 

      Given { prepare_destination 'greenfield' }

      describe 'current directory must be empty' do 
        
        Then { assert subject.confirm_directory_empty }
        And { assert_raises( Roro::Error ) { subject.confirm_directory_not_empty } }
      end
    end 
    
    describe 'for rollon story' do  
      
      Given { prepare_destination 'rails/603' }
      
      describe 'directory must not be empty' do 
        
        Then { assert subject.confirm_directory_not_empty }
        And  { assert_raises(  Roro::Error  ) { subject.confirm_directory_empty } }
      end
    end
    
    describe 'for all stories' do 
      describe '.confirm_dependencies' do
    
        Given(:dependencies) { [
          {
            system_query: "which docker",
            warning: "Docker isn't installed",
            suggestion: "https://docs.docker.com/install/"
          }, {
            system_query: "which docker-compose",
            warning: "Docker Compose isn't installed",
            suggestion: "https://docs.docker.com/compose/install/"

          }, {
            system_query: "docker info",
            warning: "the Docker daemon isn't running",
            suggestion: "https://docs.docker.com/config/daemon/#start-the-daemon-manually"
          } ] }      

        describe 'success' do 
    
          Then do
            dependencies.each do |d|
              Roro::CLI.any_instance.expects(:system).with(d[:system_query]).returns(true) 
              assert subject.confirm_dependency(d) 
            end
          end
        end 
        
        describe 'failure' do 
    
          Then do
            dependencies.each do |d| 
              Roro::CLI.any_instance.expects(:system).with(d[:system_query]).returns(false) 
              assert_raises( Roro::Error ) { subject.confirm_dependency(d ) }
            end
          end
        end
      end
    end
  end
end