require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config) { Roro::Configuration.new }
  Given(:subject){ Roro::CLI.new }
  Given(:rollon) { 
    subject.instance_variable_set(:@config, config)
    subject.rollon_rails }

  describe '.rollon with postgresql' do 

    Given { config.thor_actions['configure_database'] = 'p' }

    Given { rollon }

    describe 'pg gem in gemfile' do 
  
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'pg'", c)
        end
      end
    end
    
    describe "config/database.yml" do  
        
      Then do 
        assert_file 'config/database.yml' do |c| 
          assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
          assert_match("<%= ENV.fetch('POSTGRES_USER') %>", c)
          assert_match("<%= ENV.fetch('POSTGRES_PASSWORD') %>", c)
          assert_match("<%= ENV.fetch('POSTGRES_DB') %>", c)
        end
      end
    end
    
    describe 'env_files' do 
      Given(:vars) { config.env['postgresql_env_vars'] }
      %w(development production test staging ci).each do |env| 
        
        Then do 
          assert_file( "roro/containers/database/#{env}.env" ) do |c| 
            assert_match "POSTGRES_USER=#{vars['postgres_user']}", c 
            assert_match "POSTGRES_PASSWORD=#{vars['postgres_password']}", c 
            assert_match "POSTGRES_DB=#{config.env['main_app_name'] + "_" + env}", c 
            assert_match "RAILS_ENV=#{env}", c 
          end 
        end
      end
      And { assert_nil config.env['rails_env'] }
    end

    describe 'docker-compose.yml' do
      
      Given(:expected) { yaml_from_template('rails/database/with_postgresql/_service.yml')}
      
      Then do
        assert_file "docker-compose.yml" do |c| 
          assert_match expected, c 
        end
      end 
    end 
  end
end
