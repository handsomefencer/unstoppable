require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stubs_system_calls }
  Given { stubs_dependency_responses }
  
  Given(:options) { { story: { rails: [
    { database: { postgresql: {} }},
    { ci_cd:    { circleci:   {} }}
  ] } } }
 
  Given(:config) { Roro::Configurator.new(options) }
  Given(:cli) { Roro::CLI.new }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.rollon_rails }

  describe '.rollon with postgresql' do 

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
          assert_match("<%= ENV.fetch('POSTGRES_USERNAME') %>", c)
          assert_match("<%= ENV.fetch('POSTGRES_PASSWORD') %>", c)
          assert_match("<%= ENV.fetch('POSTGRES_DATABASE') %>", c)
        end
      end
    end
    
    describe 'env_files' do 
      Given(:vars) { config.env }
      %w(development production test staging ci).each do |env| 
        
        Then do 
          assert_file( "roro/containers/database/#{env}.env" ) do |c| 
            assert_match "POSTGRES_USERNAME=postgres", c 
            # assert_match "POSTGRES_PASSWORD=your-postgres-password", c 
            # assert_match "POSTGRES_DATABASE=#{config.env['main_app_name'] + "_" + env + "_db"}", c 
            # assert_match "RAILS_ENV=#{env}", c 
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
