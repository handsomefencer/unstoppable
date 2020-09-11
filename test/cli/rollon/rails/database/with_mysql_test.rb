require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stubs_system_calls }
  Given { stubs_dependency_responses }
  Given(:options) { { story: { rails: [
    { database: { mysql: {} }},
    { ci_cd: { circleci:   {} }}
    ] } } }
  Given(:config) { Roro::Configuration.new(options) }
  Given(:cli){ Roro::CLI.new }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.rollon_rails }
    
  describe '.rollon with mysql' do 

    Given { config.intentions[:configure_database] = 'm' }
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
      Given(:env) { config.env }
      Then { %w(development production test staging ci).each { |env| 
        assert_file( "roro/containers/database/#{env}.env" ) { |c| 
          assert_match "MYSQL_ROOT_PASSWORD=root-mysql-password", c 
          assert_match "MYSQL_PASSWORD=your-mysql-password", c 
          assert_match "MYSQL_DATABASE=#{config.env[:main_app_name] + '_' + env + '_db'}", c 
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


