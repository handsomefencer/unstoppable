require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config) { Roro::Configuration.new }
  Given(:subject){ Roro::CLI.new }
  Given(:rollon) { 
    subject.instance_variable_set(:@config, config)
    subject.rollon_rails }
    
  describe '.rollon with mysql' do 

    Given { config.thor_actions['configure_database'] = 'm' }
    Given { rollon }

    describe 'must add mysql2 gem to gemfile' do 
    
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'mysql2'", c)
        end
      end
    end   
      
    describe "config/database.yml" do  
        
      Then do 
        assert_file 'config/database.yml' do |c| 
          assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
          assert_match("<%= ENV.fetch('MYSQL_USERNAME') %>", c)
          assert_match("<%= ENV.fetch('MYSQL_PASSWORD') %>", c)
          assert_match("<%= ENV.fetch('MYSQL_DATABASE') %>", c)
          assert_match("<%= ENV.fetch('MYSQL_DATABASE_PORT') %>", c)
        end
      end
    end
    
    describe 'env_files' do 

      Then { %w(development production test staging ci).each { |env| 
        assert_file( "roro/containers/database/#{env}.env" ) { |c| 
          assert_match "MYSQL_ROOT_PASSWORD=root", c 
          assert_match "MYSQL_PASSWORD=root", c 
          assert_match "MYSQL_DATABASE=#{config.env['main_app_name'] + '_db'}", c 
          assert_match "MYSQL_USERNAME=root", c 
          assert_match "MYSQL_DATABASE_PORT=3306", c
          assert_match "RAILS_ENV=#{env}", c 
      } } }
    end

    describe 'docker-compose.yml' do
 
      Given(:expected) { yaml_from_template('rails/database/with_mysql/_service.yml')}
      
      Then { assert_file("docker-compose.yml") {|c| assert_match expected, c }}
    end 
  end
end


