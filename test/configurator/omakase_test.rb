require 'test_helper'

describe Roro::Configurator::Omakase do
  
  Given { greenfield_rails_test_base }
  Given(:config) { Roro::Configuration.new(nil) }
  
  describe '.structure' do 

    Given(:env)       { config.env } 
    Given(:structure) { config.structure }
    Given(:choices)   { config.structure[:choices] }
    Given(:base_keys) { [ 
      :choices, :ci_cd, :deployment, :env_vars, :registries, :stories  
    ] } 
    
    Given(:base_choices) { [ 
      :copy_dockerignore, :backup_existing_files, :generate_config 
    ] }
        
    describe 'base (stories.yml) keys and choices present' do 
      
      Then { base_keys.each    { |k| assert_includes structure.keys, k } }
      And  { choices.keys.each { |k| assert_includes choices.keys, k } }
    end
    
    Given(:rails_choices) { [
      :config_std_out_true, 
      :gitignore_sensitive_files, 
      :insert_hfci_gem_into_gemfile, :insert_roro_gem_into_gemfile 
    ] }
        
    Given(:rails_keys) { [:actions, :intentions] }
    
    describe 'rails story keys and choices present' do 
  
      Then { rails_keys.each { |k| assert_includes structure.keys, k } }
  
      Then { rails_choices.each { |k| assert_includes choices, k } }
    end 
      
    describe 'intentions must have default values' do 
      
      Given(:choices)    { config.structure[:choices]}
      Given(:intentions) { config.structure[:intentions] }
      
      Then { intentions.each { |k,v| assert_includes choices.keys, k } }
      And  { intentions.each { |k,v| assert_equal choices[k][:default], v } }
      And  { rails_choices.each { |k| assert_includes intentions.keys, k } }
    end
    
    describe 'actions' do 
      
      Given(:actions)    { config.structure[:actions] }
      
      describe 'rails' do 
        
        Given(:expected) { "directory 'rails/roro', './roro', @config.env" }
        
        Then { assert_includes actions, expected }
      end
      
      describe 'postgres' do 
        
        Given(:expected) { "copy_file 'rails/config/database.pg.yml', 'config/database.yml', @config.env" }
        
        Then { assert_includes actions, expected }
      end
      
      
      # And  { intentions.each { |k,v| assert_equal choices[k][:default], v } }
      # And  { rails_choices.each { |k| assert_includes intentions.keys, k } }
    end
        
    describe '.env' do 
      describe 'dynamic variables' do 
      
        Given(:expected) { [:main_app_name, :docker_username] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'greenfield', config.env[:main_app_name]}
      end
      
      describe 'rails' do 
      
        Given(:expected) { [ :main_app_name, :ruby_version ] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'greenfield', config.env[:main_app_name]}
        And  { assert_equal '2.7', config.env[:ruby_version] }
      end
      
      describe 'database: :postgresql' do 
      
        Given(:expected) { [ :postgres_username, :postgres_password ] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'postgres', config.env[:postgres_username]}
        And  { assert_equal 'postgresql', config.env[:database_vendor] }
      end
    end
  end
end