require "test_helper"

describe "Story::RubyGem::WithCICD" do 

  Given { prepare_destination 'ruby_gem/dummy_gem' }

  Given(:config)  { Roro::Configuration.new }
  Given(:subject) { Roro::CLI.new }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given(:rubygems_api_key) { 'some-rubygems-api-key' }
  Given { asker.stubs(:ask).returns(rubygems_api_key) }    
  Given { 
    subject.instance_variable_set(:@config, config)
    subject.ruby_gem_with_ci_cd
  }
  
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
  end
  
  Given(:rubies) { config.app[ 'rubies' ] }
  
  describe 'must have rubies set' do 
  
    Then { assert_equal ['2.7', '2.6', '2.5'], rubies } 
  end
 
  describe 'roro/containers/ruby_gem/Dockerfile' do 
     
    Then do  
      rubies.each do |ruby|
        from = "FROM $RUBY_IMAGE" 
        file = "roro/containers/ruby_image/Dockerfile"
        assert_file(file) { |c| assert_match from, c }  
      end
    end
  end
end