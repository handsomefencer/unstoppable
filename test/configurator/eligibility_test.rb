require 'test_helper'

describe Roro::Configurator::Eligibility do

  Given(:options) { nil }
  Given(:config)  { Roro::Configuration.new(options) }

  describe 'greenfield' do 
    
    Given { prepare_destination "greenfield/greenfield" }

    describe '.confirm_directory_app must fail' do
      describe 'errors with option :greenfield' do 

        Given(:options) { { greenfield: true } }

        Then { assert_raises( Roro::Error ) { config.confirm_directory_app } }
      end
    end
    
    describe '.confirm_directory_empty' do 
      describe 'succeeds when empty and with option :greenfield' do 
        
        Given(:options) { { greenfield: true } }
        
        Then { assert config.confirm_directory_empty }
        And  { assert config }
      end 
      
      describe 'error when' do 
        describe 'empty and' do 
          describe 'without option specified' do 
      
            Then { assert_raises( Roro::Error ) { config } }
          end
          
          describe 'with option :rollon' do 
      
            Given(:options) { { rollon: true } }           
            
            Then { assert_raises( Roro::Error ) { config } }
          end
        end
        
        describe 'not empty and' do 
          describe 'with option :greenfield' do 

            Given { prepare_destination "rails/603" }
            Given(:options) { { greenfield: true } }
          
            Then { assert_raises( Roro::Error ) { config } }
          end
        end
      end
    end
  end 
    
  describe 'rollon' do
    
    Given { prepare_destination "rails/603" }
    
    describe '.confirm_directory_app' do
      describe 'succeeds without options specified' do 
        
        Then { assert config.confirm_directory_app }
      end
      
      describe 'succeeds with option :rollon' do 

        Given(:options) { { rollon: true } }

        Then { assert config.confirm_directory_app }
      end
      
      describe 'errors with option :greenfield' do 

        Given(:options) { { greenfield: true } }

        Then { assert_raises( Roro::Error ) { config.confirm_directory_app } }
      end
      
      describe 'errors when directory empty' do 

        Given { prepare_destination "greenfield/greenfield" }
        Given(:options) { { rollon: true } }

        Then { assert_raises( Roro::Error ) { config.confirm_directory_app } }
      end
    end
  end
  
  describe '.confirm_dependencies' do

    Given(:dependencies) { config.send :dependencies}
    Given(:mock_response) { dependencies.each { |d| 
      Roro::Configuration
        .any_instance.stubs(:system)
        .with(d[:system_query])
        .returns(system_response) 
    } }

    describe 'greenfield' do 

      Given { greenfield_rails_test_base }

      describe 'success' do 
      
        Given(:system_response ) { true }
        Given { mock_response }
             
        Then { assert config.confirm_dependencies }
      end
      
      describe 'errors' do 
      
        Given(:system_response ) { false }
        Given { mock_response }

        Then { assert_raises( Roro::Error ) { config.confirm_dependencies } } 
      end
    end 
    
    describe 'rollon' do 

      Given { rollon_rails_test_base }

      describe 'success' do 
      
        Given(:system_response ) { true }
        Given { mock_response }
             
        Then { assert config.confirm_dependencies }
      end
      
      describe 'errors' do 

        Given(:system_response ) { false }
        Given { mock_response }

        Then { assert_raises( Roro::Error ) { config.confirm_dependencies } }
      end 
    end
  end
end