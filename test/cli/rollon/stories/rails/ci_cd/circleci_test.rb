require "test_helper"

describe "Story::Rails::WithCICD" do 

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config)  { Roro::Configuration.new }
    
  Given(:subject) { Roro::CLI.new }
  Given(:rollon)  { 
    subject.instance_variable_set(:@config, config)
    subject.rollon
  }
  
  Given { rollon }
  
  describe '.circleci/config.yml' do 
    
    Given(:file) { '.circleci/config.yml' }
    
    Then { assert_directory ".circleci" }
        
    describe 'must have the correct structure' do
          
      Given(:structure) { YAML.load_file('.circleci/config.yml')}
          
      Then { 
        assert_includes structure.keys, 'version'  
        assert structure['jobs']['build'] 
        assert structure['jobs']['test'] 
        assert structure['workflows']['build-and-test'] 
      }
    end 
    And  { assert_directory "roro/containers/frontend" } 
  end

    
    
  
  
  describe '.circleci/config.yml' do 
    
    Given(:file) { '.circleci/config.yml' }
    
    describe 'must have the correct structure' do
      
      Given(:structure) { YAML.load_file('.circleci/config.yml')}
      
      Then { 
        assert_includes structure.keys, 'version' 
        assert_includes structure.keys, 'jobs' 
        assert_includes structure.keys, 'workflows' 
        assert structure['jobs']['build'] 
        assert structure['jobs']['test'] 
        assert structure['workflows']['build-and-test'] 
      }
    end 
    
    #     Given(:expected) { r = rubies.first; [
      #       "version: 2.1",
      #       "- run: RUBY_VERSION=#{r} docker-compose build ruby_gem",
      #       "- run: RUBY_VERSION=#{r} docker-compose up -d --force-recreate",
      #       "- run: RUBY_VERSION=#{r} docker-compose run ruby_gem bundle exec rake",
      #     ]}
      
      #     Then { assert_file(file) {|c| expected.each {|e| assert_match e, c } }}
      #   end
      
      #   Given(:rubies) { config.app[ 'rubies' ] }
      
      #   describe 'must have rubies set' do 
      
      #     Then { assert_equal ['2.7', '2.6', '2.5'], rubies } 
      #   end
      
      #   describe 'roro/ci.env' do 
      
      #     Given(:file) { 'roro/containers/ruby_image/ci.env' }
      #     Given(:expected) { "export RUBYGEMS_API_KEY=#{rubygems_api_key}"}
      
      #     Then { assert_file(file) {|c| assert_match expected, c} } 
      #   end
      
      #   describe 'roro/containers/ruby_gem/Dockerfile' do 
      
      #     Given(:file) { "roro/containers/ruby_image/Dockerfile" }    
      
      #     Then { assert_file(file) { |c| assert_match "FROM $RUBY_IMAGE", c } }  
      #   end
      
      #   describe 'docker-compose.yml' do 
      
      #     Then { assert_file 'docker-compose.yml' } 
      #   end
    end
  end