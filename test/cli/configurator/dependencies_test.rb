require 'test_helper'

describe Roro::Configurator do

  Given { prepare_destination "greenfield/greenfield" }
  Given { stub_system_calls }
  Given(:options) { { greenfield: true } }

  Given(:config) { Roro::Configurator.new(options) }

  describe '.confirm_directory_empty' do 
    describe 'must succeed when directory is empty' do 
      
      Given { prepare_destination "greenfield/greenfield" }
        
      Then { assert config.confirm_directory_empty }
      And  { assert_raises( Roro::Error ) { config.confirm_directory_not_empty } }
    end 
    
    describe 'throws error when not empty' do 
      
      Given { prepare_destination "rails/603" }
      
      Then { assert config.confirm_directory_not_empty }
      And  { assert_raises( Roro::Error ) { config.confirm_directory_empty } }
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
              Roro::Configurator.any_instance.expects(:system).with(d[:system_query]).returns(true) 
              assert config.confirm_dependency(d) 
            end
          end
        end 
        
        describe 'failure' do 
    
          Then do
            dependencies.each do |d| 
              Roro::Configurator.any_instance.expects(:system).with(d[:system_query]).returns(false) 
              assert_raises( Roro::Error ) { config.confirm_dependency(d ) }
            end
          end
        end
      end
    end
  end
end