require "test_helper"

describe "Story::RubyGem::WithCICD" do 

  Given(:config)  { Roro::Configuration.new }
  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'ruby_gem/dummy_gem' }
    
  Given { 
    subject.instance_variable_set(:@config, config)
    subject.ruby_gem_with_ci_cd
  }

  describe '.circleci' do 
    
    Then { assert_file '.circleci/config.yml' }
    And  { assert_file 'docker-compose.yml' }
  end
  
  describe 'roro directory' do 
    
    Then { assert_directory 'roro' }
    
    describe 'containers' do 
      describe 'gem' do 

        Then { assert_directory 'roro/containers/gem' }
        
        describe 'Dockerfile' do 
          Given(:file) { 'roro/containers/gem/Dockerfile' }
          Given(:contents) { "FROM ruby:#{config.app['ruby_version']}"}

          Then { assert_file(file) {|c| assert_match contents, c} }
        end
      end
    end
  end
end
