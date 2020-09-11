require "test_helper"

describe Roro::Configuration do
  
  Given { greenfield_rails_test_base }

  Given(:config) { Roro::Configuration.new(options) }

  describe 'sanitizing options' do
    
    Given(:expected) { {:greenfield=>{}, :story=>{:rails=>{}}}}
    
    describe 'greenfield' do
      describe 'with story specified' do 
         
        Given(:options) { { greenfield: true, story: :rails } }
        Given { config }
        
        Then { assert_equal expected, config.options }
        And  { assert_includes config.options.keys, :greenfield }
      end
      
      describe 'without story uses default' do 
        
        Given(:options) { { greenfield: true } }
        Given { config }
          
        Then { assert_equal expected, config.options }
        And  { assert_includes config.options.keys, :greenfield }
      end
    end
  end
  
  describe 'when story' do
    describe 'not recognized' do 
    
      Given(:options) { { story: :nostory} }
    
      Then  { assert_raises(  Roro::Error  ) { config } }
    end
    
    Given(:expected) { { story: { rails: {} } } }
    
    describe 'nil' do  
        
      Given(:options)  { nil }
      Given { config }
      
      Then { assert_equal expected, config.options }
      And  { refute config.options.keys.include? :greenfield }
    end 
    
    describe 'contains nested hashes' do 
        
      Given(:options) { { story: { rails: {} } } }
      Given { config }
      
      Then { assert_equal expected, config.options }
    end
    
    describe 'contains symbols' do

      Given(:options) { { story: :rails } }
      Given { config }
      
      Then { assert_equal expected, config.options }
    end
    
    describe 'contains strings' do

      Given(:options) { { 'story' =>  'rails' } }
      Given { config }
      
      Then { assert_equal expected, config.options }
    end
    
    describe 'contains strings' do

      Given(:options) { { story: { rails: true } } }
      Given { config }
      
      Then { assert_equal expected, config.options }
    end
      
    describe 'contains arrays' do 
      
      Given(:options) { { story: { rails: [
        { database: { postgresql: {} }},
        { ci_cd:    { circleci:   {} }}
      ] } } }
      
      Given(:expected)  { options }
      Given { config }
    
      Then { assert_equal expected, config.options }
                      
      describe '.structure' do 
        
        Given(:env)       { config.env } 
        Given(:structure) { config.structure }
        Given(:choices)   { config.structure[:choices] }
        Given(:base_keys)    { [ 
          :choices, :ci_cd, :deployment, :env_vars, :registries  ] } 
        Given(:rails_keys)    { [:story, :intentions] }
        Given(:base_choices) { [ 
          :copy_dockerignore, :backup_existing_files, :generate_config ] }
        Given(:rails_choices) { [
          :backup_existing_files, :configure_database, :config_std_out_true, 
          :copy_dockerignore, :gitignore_sensitive_files, 
          :insert_hfci_gem_into_gemfile, :insert_roro_gem_into_gemfile ] }

        describe 'base (stories.yml) keys and choices present' do 

          Then { base_keys.each { |k| assert_includes structure.keys, k } }
          And  { choices.keys.each { |k| assert_includes choices.keys, k } }
        end
        
        describe 'rails story keys and choices present' do 
          
          Then { rails_choices.each { |k| assert_includes choices, k } }
        end 
          
        describe 'intentions must have default values' do 
          
          Given(:choices)    { config.structure[:choices]}
          Given(:intentions) { config.structure[:intentions] }
          
          Then { intentions.each { |k,v| assert_includes choices.keys, k } }
          And  { intentions.each { |k,v| assert_equal choices[k][:default], v } }
          And  { assert_equal intentions[:configure_database], 'p' }
        end
            
        describe '.env' do 
          describe 'dynamic variables' do 
         
            Given(:expected) { [:main_app_name, :ruby_version] }

            Then { expected.each { |e| assert_includes config.env.keys, e } }
            And  { assert_equal 'greenfield', config.env[:main_app_name]}
            And  { assert_equal '2.7', config.env[:ruby_version]}
          end
          
          describe 'story specific variables' do
            
            Given(:options) { { story: { rails: [
              { database: db },
              { ci_cd: { circleci:   {} }}
              ] } } }
              
            describe 'must not add mysql env vars to pg story' do \
              
              Given(:db) { { postgresql: {} } }
              Given { config }
              
              Then { assert_includes config.env, :postgres_password }
              And  { refute config.env.include? :mysql_password }
            end
            
            describe 'will not add pg env vars to myql story' do 
              
              Given(:db) { { mysql: {}} }
              Given { config }
              
              Then { assert_includes config.env, :mysql_password }
              And  { refute config.env.include? :postgres_password }
            end
          end
        end
      end
    end
  end
end