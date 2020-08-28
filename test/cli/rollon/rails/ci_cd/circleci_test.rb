require "test_helper"

describe "Story::Rails::WithCICD" do 

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config)  { Roro::Configuration.new }
  Given { config.app['force'] = true}  
  Given(:subject) { Roro::CLI.new }
  Given(:rollon)  { 
    subject.instance_variable_set(:@config, config)
    subject.rollon_rails
  }
  
  Given { rollon }
  
  describe '.circleci/config.yml' do 
    
    Given(:file) { '.circleci/config.yml' }
    
    Then { assert_directory ".circleci" }
        
    describe 'must have the correct structure' do
          
      Given(:structure) { YAML.load_file('.circleci/config.yml')}
          
      Then { 
        assert_includes structure.keys, 'aliases' 
        assert_includes structure.keys, 'version' 
        assert_includes structure.keys, 'jobs' 
        assert_includes structure.keys, 'workflows' 
        assert structure['jobs']['build'] 
        assert structure['jobs']['test'] 
        assert structure['workflows']['build-and-test'] 
      }
    end 
  end
end