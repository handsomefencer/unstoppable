require "test_helper"

describe "Story::RubyGem::WithCICD" do 

  Given(:config)  { Roro::Configuration.new }
  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'ruby_gem/dummy_gem' }
    
  Given { 
    subject.instance_variable_set(:@config, config)
    subject.ruby_gem_with_ci_cd
  }
  
  describe 'docker-compose.yml' do 
          
    Given(:file) { "docker-compose.yml" }
    Given(:lines) {["version: '3.2", "  ruby_gem:"] }

    Then { assert_file(file) {|c| lines.each {|l| assert_match l, c}}}
  end


  describe 'must modify .gitignore' do
    
    Given(:keys)    { /roro\/\*\*\/\*.key/ } 
    Given(:dotenvs) { /roro\/\*\*\/\*.env/ } 
    Given(:file)    { '.gitignore' }
      
    Then { assert_file(file) {|c| assert_match keys, c }}
    And  { assert_file(file) {|c| assert_match dotenvs, c }}
    And  { assert_file(file) {|c| assert_match 'Gemfile.lock', c }}
  end
  
  describe '.circleci' do 
    
    Then { assert_file '.circleci/config.yml' }
    And  { assert_file 'docker-compose.yml' }
  end
  
  describe 'roro directory' do 
    
    Then { assert_directory 'roro' }
    
    describe 'containers' do 
      describe 'gem' do 
        describe 'Dockerfile' do 
          
          Given(:file) { 'roro/containers/gem/Dockerfile' }
          Given(:contents) { "FROM ruby:#{config.app['ruby_version']}"}

          Then { assert_file(file) {|c| assert_match contents, c} }
        end
      end
    end
  end
end
