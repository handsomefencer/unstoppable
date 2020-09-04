require "test_helper"

describe Roro::Configuration do
  
  Given { prepare_destination "rails/603" }
  
  describe 'initialization' do
  
    Given(:config) { Roro::Configuration.new }
  
    describe 'normal flow' do
      describe '.master must get master config' do 
        
        Then { assert_equal Hash, config.master.class }
      end
      
      describe '.app' do 
        
        Then { assert_equal Hash, config.app.class}  
      end
      
      describe '.choices' do 
        describe 'must have question, choices, and default keys' do 
          
          Then { config.choices.each { |key, value| 
            assert_equal value.keys, %w(question choices default)
            assert_equal value['choices'].class, Hash
            assert_equal value['default'].class, String
          } }
        end
      end
        
      env_vars = {
        main_app_name: '603', 
        ruby_version: `ruby -v`.scan(/\d.\d/).first.to_s,
        database_service: 'database',
        database_vendor: 'postgresql',
        frontend_service: 'frontend',
        webserver_service: 'nginx',
      }
      
      config_methods = [
        "config.configure",
        "config.set_from_defaults",
      ].each do |cm| 
        env_vars.each do |key, value| 
          describe ".#{cm} must set #{key} to #{value}" do 
        
            Given { eval(cm) }
            
            # Then { assert_equal value, config.app[key.to_s] }          
          end
        end
        
        describe 'must set up default thor actions' do 

          Then { assert_includes config.thor_actions.keys, thor_action }
          And { assert_equal default_answer, config.thor_actions[thor_action]}
        end
      end
    end
    
    Given(:config_file) { '.roro_config.yml' }
    Given(:default_app_name)   { '603' }
    Given(:config_app_name)    { '603' }
    Given(:thor_action)        { 'insert_hfci_gem_into_gemfile' }
    Given(:default_answer)     { 'n' }
    Given(:config_answer)      { 'y' }
    Given(:interactive_answer) { 'z' }
    
    describe 'without config file' do
      describe 'must return default app name' do 
        
        # Then { assert_equal default_app_name, config.app['main_app_name'] }
      end
      
      describe 'must return default thor_actions' do
        
        Then { assert_equal default_answer, config.thor_actions[thor_action] }
      end  
    end
    
    describe 'with config file' do
      
      Given { insert_file "base/#{config_file}", config_file }
      describe 'must override default main_app_name using config' do 
        
        Then { assert_equal config_app_name, config.app['main_app_name']  }
      end 
      
      describe 'must override default thor_actions using config' do 
        
        Then  { assert_equal 'y', config.thor_actions[thor_action] }
      end
    end 
    
    describe 'interactive path' do
      
      Given(:config) { Roro::Configuration.new(options)}        
      Given(:options) { { "interactive"=>"interactive" } }
      Given(:asker) { Thor::Shell::Basic.any_instance }
      Given { asker.stubs(:ask).returns(interactive_answer) }
        
      describe 'must override default answer' do 
        
        Then  { assert_equal config.thor_actions[thor_action], interactive_answer }
      end
      
      describe 'must override config answer' do 

        Given { insert_file "base/#{config_file}", config_file }
        Given(:expected) {config.thor_actions[thor_action] }
        
        Then  { assert_equal expected, interactive_answer }
      end
    end
  end  
end