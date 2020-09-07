require 'test_helper'

describe Roro::Configurator do

  Given(:options)    { nil }
  Given(:config)     { Roro::Configurator.new(options) }
  
  describe '.confirm_directory_empty when' do 
    describe 'directory empty' do 
      
      Given { prepare_destination "greenfield/greenfield" }
      
      describe 'succeeds when option :greenfield' do 
        
        Given(:options) { { greenfield: true } }
          
        Then { assert config }
        And  { assert config.confirm_directory_empty }
      end 
      
      describe 'errors when option :rollon' do 
        
        Given(:options) { { rollon: true } }           
          
        Then { assert_raises( Roro::Error ) { config } }
      end 
    end

    describe 'directory holds an app' do 

      Given { io_confirm }  
      Given { prepare_destination "rails/603" }

      describe 'succeeds when option :rollon' do 
        
        Given(:options) { { rollon: true } }           

        Then { assert config }
        And  { assert config.confirm_directory_app }
      end

      describe 'errors when option :greenfield' do 

        Given(:options) { { greenfield: true } }

        Then { assert_raises( Roro::Error ) { config } }
      end 
    end
  end 
  
  Given(:io_confirm) { IO.stubs(:popen).returns([]) }  
  Given(:io_deny)    { IO.stubs(:popen).returns([1]) }  
  
  describe '.confirm_dependencies' do
    
    Given { prepare_destination "rails/603" }
    Given { io_confirm }

    describe '.confirm_dependencies' do

      Given(:deps) { config.send :dependencies}
      Given { Roro::Configurator.any_instance.stubs(:handle_roro_artifacts) }
      
      Given(:mock_response) { deps.each { |d| Roro::Configurator
        .any_instance.expects(:system)
        .with(d[:system_query])
        .returns(system_response) 
      } }
      
      describe 'must succeed when response is true' do
        
        Given(:system_response ) { true }
        Given { mock_response }
        
        Then { deps.each { |d| assert config.confirm_dependency(d) } }
      end 
      
      describe 'must error when response is false' do
        
        Given(:system_response ) { false }
        Given { mock_response }
        
        Then { deps.each { |d| assert_raises( Roro::Error ) { 
          config.confirm_dependency(d ) 
        } } }
      end
    end
  end
end