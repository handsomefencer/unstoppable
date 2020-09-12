require "test_helper"

describe Roro::Configuration do
  
  ## omakase needs to handle everything that is default. Okanomi handles 
  ## everything that is configured via a) config file or b) interrogation. 
  
  Given { greenfield_rails_test_base }

  Given(:config) { Roro::Configuration.new(options) }
  
  describe 'when story' do
    
    Given(:expected) { { story: { rails: {} } } }
    
    describe 'nil' do  
        
      Given(:options)  { nil }
      Given { config }
      
      Then { assert_equal expected, config.options }
      And  { refute config.options.keys.include? :greenfield }
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
          :backup_existing_files, :config_std_out_true, 
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
            Given { skip }  
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