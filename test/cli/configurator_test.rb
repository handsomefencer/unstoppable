require "test_helper"

describe Roro::Configurator do
  
  Given(:options) { { story: 'rails' } }
  Given(:cli)    { Roro::CLI.new}
  Given(:config) { Roro::Configurator.new(options) }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.configurator_for_rollon
  }
  
  describe 'with roro_configurator.yml' do 
    Given { skip }    
    Given { prepare_destination "greenfield/rails_story" }
  
    describe 'must throw error if stories do not match' do 
    
      When(:options) { { 'story' => 'ruby_gem'} }
      Then  { assert_raises(  Roro::Error  ) { rollon } }
    end
    
    describe 'must throw error if story not recognized' do 
    
      When(:options) { { 'story' => 'nostory'} }
      Then  { assert_raises(  Roro::Error  ) { rollon } }
    end
  end
  
  describe '.structure' do 
  Given { skip }  
    Given(:base_keys) { [ 'env_vars', 'registries', 'ci_cd', 'deployment', 
                          'choices', 'story', 'intentions' ] }
    Given(:base_choices) { %w(copy_dockerignore backup_existing_files) }
    Given(:structure)    { config.structure.keys }
    Given(:choices)      { config.structure['choices'].keys }
    
    describe 'without roro_configurator.yml' do 
      
      Given { prepare_destination "greenfield/greenfield" }
      Given { rollon }        
      
      describe 'base' do 
        
        Then { base_keys.each { |k| assert_includes structure, k } }
        And  { base_choices.each { |k| assert_includes choices, k } }
      end
      
      describe 'rails' do
        describe 'choices' do 
          
          Given(:expected_choices) { [
            'copy_dockerignore', 'backup_existing_files', 'config_std_out_true',
            'insert_roro_gem_into_gemfile', 'gitignore_sensitive_files', 
            'insert_hfci_gem_into_gemfile' 
            ] }
          Then { expected_choices.each { |k| assert_includes choices, k } }
        end
        
        describe 'intentions must have default values' do 
          
          Given(:intentions) { config.structure['intentions'] }
          Given(:choices) { config.structure['choices']}

          Then { intentions.each { |k, v| 
            assert_includes choices.keys, k
            assert_equal choices[k]['default'], v 
          }}
        end
        
        describe '.env' do 
          
          Given(:env_vars) { config.env }
          Given(:expected) { ['main_app_name', 'ruby_version'] }

          Then { expected.each { |e| assert_includes env_vars.keys, e } }
        end
      end
    end
  end
  
  describe 'story' do 
    describe 'simple' do 
      Given(:options) { { 'story'=> 'rails' }}
      Given { rollon }
      
      Then { assert_equal 'stories', config.structure['story'].keys.first }  
      And  { assert_equal 'rails', config.structure['story']['stories'].keys.first }  
    end
    
    describe 'default' do 
      Given(:options) { nil }
      Given { rollon }
      
      Then { assert_equal 'stories', config.structure['story'].keys.first }  
      And  { assert_equal 'rails', config.structure['story']['stories'].keys.first }
    end

    describe 'nested' do
     
      Given(:options) { { 'story' => { 'rails' => { 
              'ci_cd' => 'circleci',
              'database'=> 'postgresql' } } } }
      Given { rollon }
   
      Then { assert_equal 'stories', config.structure['story'].keys.first }
      And  { assert_equal 'rails', config.structure['story']['stories'].keys.first }
      And { assert config.structure['env_vars']['deploy_tag'] }
      And { assert config.structure['env_vars']['postgres_pass'] }
    end
  end
end