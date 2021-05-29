require 'test_helper'

describe Roro::Configurator::Omakase do
  before { skip }
  Given { greenfield_rails_test_base }

  Given(:options) { nil }
  Given(:config)  { Roro::Configuration.new(options) }
  
  describe '.structure' do 

    Given(:env)       { config.env } 
    Given(:structure) { config.structure }
    Given(:choices)   { config.structure[:choices] }
    Given(:base_keys) { [ :choices, :env_vars, :stories ] } 
    
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
  
      And { rails_choices.each { |k| assert_includes choices, k } }
    end 
      
    describe 'intentions must have default values' do 
      
      Given(:choices)    { config.structure[:choices]}
      Given(:intentions) { config.structure[:intentions] }
      
      Then { intentions.each { |k,v| assert_includes choices.keys, k } }
      And  { intentions.each { |k,v| assert_equal choices[k][:default], v } }
      And  { rails_choices.each { |k| assert_includes intentions.keys, k } }
    end
    
    describe 'actions' do 
      
      Given(:actions)       { config.structure[:actions] }
      Given(:rails_actions) { [
        "template 'rails/.circleci/config.yml.tt', './.circleci/config.yml'", 
        "template 'rails/docker-compose.yml.tt', './docker-compose.yml', @config.smart.env",
        "template 'base/dotenv', './.smart.env', @config.smart.env",
        "directory 'rails/roro', './roro', @config.smart.env"
      ] }
      
      describe 'rollon' do 
        
        Given(:options) { nil }  
        
        Then { rails_actions.each { |e| assert_includes actions, e } }
      end
      
      describe 'omakase' do
        
        Given(:options) { { greenfield: :greenfield } }  
        Given(:greenfield_actions)  { config.structure[:greenfield_actions] }
        Given(:greenfield_commands) { config.structure[:greenfield_commands] }
        
        describe 'must store omakase actions' do

          Given(:expected) { [
            "@config.smart.env['force'] = true",
            [
              "src = 'rails/Dockerfile.omakase.tt'",
              "dest = 'roro/containers/app/Dockerfile'",
              "template src, dest, @config.smart.env\n"].join("\n")
          ] }
    
          Then { expected.each { |e| assert_includes greenfield_actions, e } }
        end
        
        describe 'must store omakase commands' do
        
          Given(:expected) { [
            "system \"DOCKER_BUILDKIT=1 docker build --file roro/containers/app/Dockerfile --output . .\""
          ] }
            
          Then { expected.each { |e| assert_includes greenfield_commands, e } }
        end
      end
      
      describe 'postgres' do 
        Given(:expected) { [
          `Roro::Cli.roro_environments.each do |environment| 
            src = 'rails/dotenv/web.smart.env.tt'
            dest = "roro/containers/app/#{environment}.smart.env"
            template src, dest, @config.smart.env
        end`
      ]}
      end
    end
        
    describe '.smart.env' do
      describe 'dynamic variables' do 
      
        Given(:expected) { [:main_app_name, :docker_username] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'omakase', config.env[:main_app_name]}
      end
      
      describe 'rails' do 
      
        Given(:expected) { [ :main_app_name, :ruby_version ] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'omakase', config.env[:main_app_name]}
        And  { assert_match /\d.\d./, config.env[:ruby_version] }
      end
      
      describe 'database: :postgresql' do 
      
        Given(:expected) { [ :postgres_username, :postgres_password ] }

        Then { expected.each { |e| assert_includes config.env.keys, e } }
        And  { assert_equal 'postgres', config.env[:postgres_username]}
        And  { assert_equal 'postgresql', config.env[:database_vendor] }
      end
    end
  end
  
  describe 'sanitizing when options contain' do

    Given(:expected) { { story: :rails } }
    Given(:actual) { config.sanitize(options) }
    
    describe 'proper formatting' do 
      
      Given(:options) { expected }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'nested hashes' do 
        
      Given(:options) { { story: :rails } }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'nil' do 
        
      Given(:expected) { {} }
      Given(:options) { nil }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'symbols' do

      Given(:options) { { story: :rails } }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'strings' do

      Given(:options) { { 'story' =>  'rails' } }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'booleans' do

      Given(:options)  { { story: { rails: true } } }
      Given(:expected) { options }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'contains arrays' do 

      Given(:expected) { { story: { rails: [
        { database: { postgresql: {} }},
        { ci_cd:    { circleci:   {} }}
      ] } } }

      Given(:options) { { story: { rails: [
        { database: { 'postgresql' => {} }},
        { ci_cd:    { circleci:   {} }}
      ] } } }
      
      Given(:expected)  { options }
   
      Then { assert_equal expected, actual } 
    end
  end
  
  describe '.story_map' do 
    Given { skip }
    describe 'rollon' do 
      Given(:story_map) { [
        {:rails=>[
          {:ci_cd=>[
                  {:circleci=>[]}
          ]}, 
          {:kubernetes=>[
                  {:postgresql=>[
                          {:default=>[]}, 
                          {:edge=>[]}]}
                  ]}, 
          {:database=>[
                  {:postgresql=>[]}, 
                  {:mysql=>[]}]}
          ]}, 
        {:ruby_gem=>[]}   
      ]}

      Then { assert_equal( story_map, config.story_map(:rollon) )}
    end
  end
  
  describe 'story' do 
    
    Given(:default_story)  { 
      { rollon: 
        { rails: [
          { database: :postgresql },
          { ci_cd: :circleci },
          { kubernetes: :postgresql }
    ] } } }
    
    describe '.default_story' do 
      describe 'no story specified' do 

        Given(:expected)  { default_story} 
        
        Then { assert_equal expected, config.default_story }
        And  { assert_equal expected, config.story }
      end
    end 
    
    
    describe 'custom story' do 

      describe 'when same as default_story' do 
      
        Given(:options)  { 
          { story: 
            { rails: [
              { database: :postgresql },
              { ci_cd: :circleci },
              { kubernetes: :postgresql }
        ] } } }
  
        Given(:expected)  { default_story} 
        
        Then  { assert_equal default_story, config.story }
      end
            
      describe 'when different substory' do 
        
        Given(:options)  { 
          { story: 
            { rails: [
              { database: :mysql },
              { ci_cd: :circleci },
              { kubernetes: :postgresql }
        ] } } }

        Given(:expected)  { default_story} 
        
        Then { assert_equal options[:story], config.story[:rollon] }
      end
    end
    
    describe 'story not recognized' do 

      Given(:options) { { story: :nostory} }
    
      Then  { assert_raises(  Roro::Error  ) { config } }
    end
  end
end