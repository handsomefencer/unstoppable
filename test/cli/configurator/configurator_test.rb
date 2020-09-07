require "test_helper"

describe Roro::Configurator do

  Given { prepare_destination "greenfield/greenfield" }
  Given { stub_system_calls }

  Given(:config) { Roro::Configurator.new(options) }
                      
  describe 'story' do
    # Given { skip }
    describe 'default' do 
      Given(:expected) { { story: { rails: {}} }} 
      
      describe 'options nil' do  
        
        Given(:options) { nil }
        Given { config }
        
        Then { assert_equal expected, config.options }
      end
      
      describe 'options same as default' do 
        
        Given(:options) { { story: { rails: {} } } }
        Given { config }
        
        Then { assert_equal expected, config.options }
      end
    end
      
    describe 'specified' do 
      describe 'options specified' do 
          
        Given(:expected) { { story: { rails: [
          { database: { postgresql: {} }},
          { ci_cd:    { circleci:   {} }}
        ] } } }
        
        describe 'option value is :symbol' do 
        
          Given(:options)  { expected }
          Given { config }
        
          Then { assert_equal expected, config.options }
        end
        
        describe 'option value is :symbol' do 
        
          Given(:options)  { { story: { rails: [
            { database: :postgresql },
            { ci_cd: :circleci } 
           ] } } }
          Given { config }
        
          Then { assert_equal expected, config.options }
        end
      end
    end 
  end
                    
  Given(:env_vars)  { config.structure[:env_vars].keys } 
  Given(:structure) { config.structure.keys }
  Given(:choices)   { config.structure[:choices].keys }

  describe 'must throw error if story not recognized' do 
  
    When(:options) { { story: :nostory} }
  
    Then  { assert_raises(  Roro::Error  ) { config } }
  end
  
  describe '.structure with rails (default) story' do 
    
    Given(:options) { { story: { rails: [
      { database: { postgresql: {} }},
      { ci_cd:    { circleci:   {} }}
    ] } } }

    Given(:base_keys)    { [ 
      :choices,
      :ci_cd, 
      :deployment, 
      :env_vars, 
      :registries  ] } 
    
    Given(:base_choices) { [ :copy_dockerignore, :backup_existing_files ] }
    
  
    describe 'base (stories.yml) keys and choices present' do 

      Then { base_keys.each { |k| assert_includes structure, k } }
      And  { choices.each { |k| assert_includes choices, k } }
    end
    
    describe 'rails keys and choices present' do 

      Given(:rails_keys)    { [:story, :intentions] }
      Given(:rails_choices) { [
        :backup_existing_files, 
        :configure_database,
        :config_std_out_true, 
        :copy_dockerignore, 
        :gitignore_sensitive_files, 
        :insert_hfci_gem_into_gemfile, 
        :insert_roro_gem_into_gemfile 
      ] }
      
      Then { rails_choices.each { |k| assert_includes choices, k } }
        
      describe 'intentions must have default values' do 
        
        Given(:intentions) { config.structure[:intentions] }
        Given(:choices) { config.structure[:choices]}
        
        Then { intentions.each { |k,v| assert_includes choices.keys, k } }
        And  { intentions.each { |k,v| assert_equal choices[k][:default], v } }
        And  { assert_equal intentions[:configure_database], 'p' }
      end
        
      describe '.env' do 
        
        Given(:expected) { [:main_app_name, :ruby_version] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'greenfield', config.env[:main_app_name]}
        And  { assert_equal '2.7', config.env[:ruby_version]}
      end
    end
  end
  
  describe 'story specific variables' do
    
    Given(:options) { { story: { rails: [
      { database: db },
      { ci_cd: { circleci:   {} }}
    ] } } }

    describe 'must not add mysql env vars to pg story' do \

      Given(:db) { { postgresql: {} } }
      Given { config }
      
      Then { assert_includes env_vars, :postgres_password }
      And  { refute env_vars.include? :mysql_password }
    end
      
    describe 'will not add pg env vars to myql story' do 
    
      Given(:db) { { mysql: {}} }
      Given { config }
          
      Then { assert_includes env_vars, :mysql_password }
      And  { refute env_vars.include? :postgres_password }
    end
  end
end
