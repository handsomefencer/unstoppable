require "test_helper"

describe Roro::Configurator do

  Given { prepare_destination "greenfield/greenfield" }
  Given { stub_system_calls }

  Given(:options)   { { 'story' => { 'rails' => {} } } } 
  Given(:config)    { Roro::Configurator.new(options) }
  Given(:env_vars)  { config.structure['env_vars'].keys } 
  Given(:structure) { config.structure.keys }
  Given(:choices)   { config.structure['choices'].keys }
  Given(:cli)       { Roro::CLI.new}
  Given(:rollon)    { cli.instance_variable_set(:@config, config)
                      cli.configure_for_rollon }  
                      
  describe 'must throw error if story not recognized' do 
  
    When(:options) { { 'story' => 'nostory'} }
  
    Then  { assert_raises(  Roro::Error  ) { rollon } }
  end
  
  describe '.structure with rails (default) story' do 
    
    Given(:base_keys)    { %w( env_vars registries ci_cd deployment choices ) }
    Given(:base_choices) { %w( copy_dockerignore backup_existing_files ) }
    
    Given { rollon }        
  
    describe 'base (stories.yml) keys and choices present' do 
      
      Then { base_keys.each { |k| assert_includes structure, k } }
      And  { choices.each { |k| assert_includes choices, k } }
    end
    
    describe 'rails keys and choices present' do 
      
      Given(:rails_keys)    { %w( story intentions ) }
      Given(:rails_choices) { %w( copy_dockerignore backup_existing_files
        config_std_out_true insert_roro_gem_into_gemfile 
        gitignore_sensitive_files insert_hfci_gem_into_gemfile ) }
      
      Then { rails_choices.each { |k| assert_includes choices, k } }
        
      describe 'intentions must have default values' do 
        
        Given(:intentions) { config.structure['intentions'] }
        Given(:choices) { config.structure['choices']}
        
        Then { intentions.each { |k,v| assert_includes choices.keys, k } }
        And  { intentions.each { |k,v| assert_equal choices[k]['default'], v } }
        And  { assert_equal intentions['configure_database'], 'p' }
      end
        
      describe '.env' do 
        
        Given(:env_vars) { config.env }
        Given(:expected) { ['main_app_name', 'ruby_version'] }

        Then { expected.each { |e| assert_includes env_vars.keys, e } }
        And  { assert_equal 'greenfield', config.env['main_app_name']}
        And  { assert_equal '2.7', config.env['ruby_version']}
      end
    end
  end
  
  describe 'stories' do 
    describe 'simple' do 
      
      Given { options = { 'story' => { 'rails' => {}}}}
      Given { rollon }
      
      Then { assert_equal 'stories', config.structure['story'].keys.first }  
      And  { assert_equal 'rails', config.structure['story']['stories'].keys.first }  
    end
    
    describe 'default' do 
      
      Given { options = nil }
      Given { rollon }
      
      Then { assert_equal 'stories', config.structure['story'].keys.first }  
      And  { assert_equal 'rails', config.structure['story']['stories'].keys.first }
    end
  end
    
  Given(:set_db) { options.merge!({'story' => {'rails' => { 'database' => db }} })}
  
  describe 'story specific variables' do
    describe 'must not add mysql env vars to pg story' do \
      
      Given(:db) { 'postgresql' }
      Given { set_db }
      Given { rollon }
      
      Then { assert_includes env_vars, 'postgres_password' }
      And  { refute env_vars.include? 'mysql_password' }
    end
      
    describe 'will not add pg env vars to myql story' do 
    
      Given(:db) { 'mysql' }
      Given { set_db }
      Given { rollon }
          
      Then { assert_includes env_vars, 'mysql_password' }
      And  { refute env_vars.include? 'postgres_password' }
    end
  end
end
