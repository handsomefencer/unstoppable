require "test_helper"

describe Roro::Configurator do
  
  Given(:options) { { story: 'rails' } }
  Given(:cli) { Roro::CLI.new}
  Given(:config) { Roro::Configurator.new(options) }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.configurator_for_rollon
  }
  
  describe 'with roro_configurator.yml' do 
  
    Given { prepare_destination "greenfield/rails_story" }
  
    describe 'must throw error if stories do not match' do 
    
      When(:options) { { 'story' => 'ruby_gem'} }
      Then  { assert_raises(  Roro::Error  ) { rollon } }
    end
  end
  
  describe 'initialization' do
    describe '.structure' do 
      
      Given(:base_keys) { 
        [
          'environment', 'registries', 'ci_cd', 'deployment', 'choices', 'story'] 
        }
      Given(:base_choices) { %w(copy_dockerignore backup_existing_files) }
      Given(:structure) { config.structure.keys }
      Given(:choices)   { config.structure['choices'].keys }
      
      describe 'without roro_configurator.yml' do 
        
        Given { rollon }        
        Given { prepare_destination "greenfield" }
        
        Then { base_keys.each { |k| assert_includes structure, k } }
        # And  { base_choices.each { |k| assert_includes choices, k } }
        
        describe 'will not have rails specific choices' do 
        
          # Then  { refute_includes structure['choices'].keys, 'story' }
        end
      end
      
      describe 'with roro_configurator.yml and rails story' do 
        
        # Given { prepare_destination "rails/greenfield" }
        
        # Then { base_keys.each { |k| assert_includes structure, k } }
        # And  { base_choices.each { |k| assert_includes choices, k }}
        
        describe 'must also have a story' do 
          
          # Then { assert_includes structure, 'story' }
        end
        # Then  { assert_includes structure['choices'].keys, 'story' }
      end
    end
    
    
    describe 'with rails option' do 
      # Given(:options) { { 'story' => 'rails'} }
      # Then { byebug }
    
    
    end
    # describe 'with roro_config.yml' do
    #   Given { prepare_destination "greenfield" }
    #   describe '.deployer' do 
        
    #     # Then { assert_equal Hash, config.deployer.class }
    #   end
    # end
    
    describe 'without roro_config.yml' do
    #   describe '.choices' do 
    #     describe 'must have question, choices, and default keys' do 
          
    #       Then { config.choices.each { |key, value| 
    #         assert_equal value.keys, %w(question choices default)
    #         assert_equal value['choices'].class, Hash
    #         assert_equal value['default'].class, String
    #       } }
    #     end
    #   end
        
    #   env_vars = {
    #     main_app_name: '603', 
    #     ruby_version: `ruby -v`.scan(/\d.\d/).first.to_s,
    #     database_service: 'database',
    #     database_vendor: 'postgresql',
    #     frontend_service: 'frontend',
    #     webserver_service: 'nginx',
    #   }
      
    #   config_methods = [
    #     "config.configure",
    #     "config.set_from_defaults",
    #   ].each do |cm| 
    #     env_vars.each do |key, value| 
    #       describe ".#{cm} must set #{key} to #{value}" do 
        
    #         Given { eval(cm) }
            
    #         Then { assert_equal value, config.app[key.to_s] }          
    #       end
    #     end
        
    #     describe 'must set up default thor actions' do 

    #       Then { assert_includes config.thor_actions.keys, thor_action }
    #       And { assert_equal default_answer, config.thor_actions[thor_action]}
    #     end
    #   end
    # end
    
    # Given(:config_file) { '.roro_config.yml' }
    # Given(:default_app_name)   { '603' }
    # Given(:config_app_name)    { 'greenfield' }
    # Given(:thor_action)        { 'insert_hfci_gem_into_gemfile' }
    # Given(:default_answer)     { 'n' }
    # Given(:config_answer)      { 'y' }
    # Given(:interactive_answer) { 'z' }
    
    # describe 'without config file' do
    #   describe 'must return default app name' do 
        
    #     Then { assert_equal default_app_name, config.app['main_app_name'] }
    #   end
      
    #   describe 'must return default thor_actions' do
        
    #     Then { assert_equal default_answer, config.thor_actions[thor_action] }
    #   end  
    # end
    
    # describe 'with config file' do
      
    #   Given { insert_file "base/#{config_file}", config_file }
    #   describe 'must override default main_app_name using config' do 
        
    #     Then { assert_equal config_app_name, config.app['main_app_name']  }
    #   end 
      
    #   describe 'must override default thor_actions using config' do 
        
    #     Then  { assert_equal 'y', config.thor_actions[thor_action] }
    #   end
    # end 
    
    # describe 'interactive path' do
      
    #   Given(:config) { Roro::Configuration.new(options)}        
    #   Given(:options) { { "interactive"=>"interactive" } }
    #   Given(:asker) { Thor::Shell::Basic.any_instance }
    #   Given { asker.stubs(:ask).returns(interactive_answer) }
        
    #   describe 'must override default answer' do 
        
    #     Then  { assert_equal config.thor_actions[thor_action], interactive_answer }
    #   end
      
    #   describe 'must override config answer' do 

    #     Given { insert_file "base/#{config_file}", config_file }
    #     Given(:expected) {config.thor_actions[thor_action] }
        
    #     Then  { assert_equal expected, interactive_answer }
    #   end
    end
  end  
end