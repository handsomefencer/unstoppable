require "test_helper"

describe Roro::Configuration do
  
  Given { prepare_destination "rails/603" }
  
  env_vars = {
    main_app_name: '603', 
    ruby_version: `ruby -v`.scan(/\d.\d/).first.to_s,
    database_service: 'database',
    database_vendor: 'postgresql',
    frontend_service: 'frontend',
    webserver_service: 'nginx',
  }
    
  Given(:config) { Roro::Configuration.new }
  
  Given { config }

  describe '.master' do 

    Then { assert_equal Hash, config.master.class }
  end

  describe '.app' do 
    
    Then { assert_equal Hash, config.app.class}  
  end
    
  ["config.set_thor_actions_from_defaults", "config.set_from_defaults"].each do |command| 

    describe ".#{command}" do 
      
      Given { eval(command) }
      
      describe 'must set up correct thor actions' do 

        Given { command }
        
        Then { assert_includes config.thor_actions["config_std_out_true"], 'y' }
      end
    end     
  end

  ["config.set_app_variables_from_defaults", "config.set_from_defaults"].each do |command| 
    
    describe ".#{command}" do 
      
      Given { eval(command) }
      
      describe 'must set correct app variables' do 
    
        env_vars.each do |key, value| 
          
          describe "key '#{key}' must return value '#{value}' " do 
            
            Then do 
              assert_equal value, config.app[key.to_s]          
            end
          end
        end
      end 
    end
  end
  
  describe '.choices' do 
    describe 'must have question, choices, and default keys' do 
   
      Given(:questions) { config.choices } 
      
      Then do 
        questions.each do |key, value| 
          assert_equal value.keys, %w(question choices default)
          assert_equal value['choices'].class, Hash
          assert_equal value['default'].class, String
        end 
      end
    end
  end 
    
  describe '.set_from_roro_config' do 
    
    Given { insert_file 'base/.roro_config.yml.tt', ".roro_config.yml"}
    
    describe 'default values' do 
      
      Given { config.set_from_defaults }
      
      Then { assert_equal config.app['main_app_name'], '603' }
      And  { assert_includes ['y', 'n'], config.thor_actions['insert_hfci_gem_into_gemfile'] }
    end
    
    describe 'over-writes default from file' do 
      
      Given { config.set_from_roro_config }
      
      Then  { assert_equal config.app['app_name'], 'your-project-name' }
    end
    
    describe 'over-writes thor actions from file' do 
      
      Given { config.set_from_roro_config }
      
      Then  { assert_equal config.thor_actions['insert_hfci_gem_into_gemfile'], 'n' }
    end
  end
end  
