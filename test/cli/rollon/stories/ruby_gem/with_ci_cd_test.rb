require "test_helper"

describe "Story::RubyGem::WithCICD" do 

  Given { prepare_destination 'ruby_gem/dummy_gem' }

  Given(:config)  { Roro::Configuration.new }
  Given(:subject) { Roro::CLI.new }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given(:rubygems_api_key) { 'some-rubygems-api-key' }
  Given { asker.stubs(:ask).returns(rubygems_api_key) }    
  Given { subject.instance_variable_set( :@config, config ) }
  Given { subject.ruby_gem_with_ci_cd }
  
  describe 'must modify .gitignore' do
    
    Given(:keys)    { /roro\/\*\*\/\*.key/ } 
    Given(:dotenvs) { /roro\/\*\*\/\*.env/ } 
    Given(:file)    { '.gitignore' }
      
    Then { assert_file(file) {|c| assert_match keys, c }}
    And  { assert_file(file) {|c| assert_match dotenvs, c }}
    And  { assert_file(file) {|c| assert_match 'Gemfile.lock', c }}
  end
  
  describe '.circleci/config.yml' do 
    
    Given(:file) { '.circleci/config.yml' }
    Given(:expected) { r = rubies.first; [
      "- checkout",
      "- run: RUBY_IMAGE=ruby:#{r}-alpine docker-compose build ruby_gem",
      "- run: RUBY_IMAGE=ruby:#{r}-alpine docker-compose run ruby_gem rake test",
      "- run: gem install roro",
      "- run: roro generate::exposed",
      "- run: echo 'source roro/ci.env' >> $BASH_ENV",
      "- run: gem install gem-release",
      "- run: gem release --key $RUBYGEMS_API_K" 
    ]}

    Then { assert_file(file) {|c| expected.each {|e| assert_match e, c } }}
  end
  
  Given(:rubies) { config.app[ 'rubies' ] }
  
  describe 'must have rubies set' do 
  
    Then { assert_equal ['2.7', '2.6', '2.5'], rubies } 
  end
  
  describe 'roro/ci.env' do 
    
    Given(:expected) { "export RUBYGEMS_API_KEY=#{rubygems_api_key}"}

    Then { assert_file('roro/ci.env') {|c| assert_match expected, c} } 
  end
 
  describe 'roro/containers/ruby_gem/Dockerfile' do 

    Given(:file) { "roro/containers/ruby_image/Dockerfile" }    

    Then { assert_file(file) { |c| assert_match "FROM $RUBY_IMAGE", c } }  
  end
  
  describe 'docker-compose.yml' do 
     
    Then { assert_file 'docker-compose.yml' } 
  end
end