require_relative "base_test"

describe Roro::CLI do
  Given { skip }
  get_configuration

  describe '.copy_dockerignore' do 

    Given { cli.copy_dockerignore }
    
    Then { assert_file '.dockerignore' }
  end

  describe '.copy_config_database_yml' do 
    Given { cli.copy_config_database_yml }
    
    Then do 
      assert_file 'config/database.yml' do |c| 
        assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
        assert_match("<%= ENV.fetch('POSTGRES_USER') %>", c)
        assert_match("<%= ENV.fetch('POSTGRES_PASSWORD') %>", c)
        assert_match("<%= ENV.fetch('POSTGRES_DB') %>", c)
      end
    end
  end
  
  describe '.copy_config_database_yml' do 
    Given { cli.copy_docker_compose }
      
    Then do 
      assert_file 'docker-compose.yml' do |c| 
        assert_match("#{env_vars[:app_name]}:", c )
        assert_match("dockerfile: roro/containers/#{env_vars[:app_name]}/Dockerfile", c )
        assert_match("#{env_vars[:app_name]}-data:/usr/src/#{env_vars[:app_name]}", c )
        assert_match("- #{env_vars[:app_name]}", c)
        assert_match("- roro/containers/database/development.env", c)
        assert_match("database:", c)
        assert_match("- database-data:", c)
      end
    end 
  end
  
  describe '.copy_roro' do 
    Given { cli.copy_roro }
    
    describe 'containers' do 
      describe 'app_name' do 
        describe 'Dockerfile' do 
          Given { skip }
          Then do 
            assert_file "roro/containers/app/Dockerfile" do |c| 
              assert_match "FROM ruby:#{env_vars[:ruby_version]}", c
              assert_match "maintainer=\"#{env_vars[:dockerhub_email]}", c
              assert_match "COPY Gemfile* /usr/src/#{env_vars[:app_name]}", c
              assert_match "WORKDIR /usr/src/#{env_vars[:app_name]}", c
              assert_match "COPY . /usr/src/#{env_vars[:app_name]}", c
            end
          end 
        end
        
        describe 'development.env' do
          Then do  
            assert_file "roro/containers/app/development.env" do |c| 
              assert_match "DATABASE_HOST=#{env_vars[:database_container]}", c
            end 
          end
        end
        
        describe 'test.env' do
          Then do  
            assert_file 'roro/containers/#{env_vars[:app_name]}/test.env' do |c| 
              assert_match "DATABASE_HOST=#{env_vars[:database_container]}", c
            end 
          end
        end
      end
      
      describe 'database_container' do 
        describe 'development.env' do
          Then do  
            assert_file 'roro/containers/database/development.env' do |c| 
              assert_match "POSTGRES_USER=#{env_vars[:postgres_user]}", c
              assert_match "POSTGRES_PASSWORD=#{env_vars[:postgres_password]}", c
              assert_match "POSTGRES_DB=#{env_vars[:app_name] + '_development'}", c
              assert_match "RAILS_ENV=development", c
            end 
          end
        end
        
        describe 'development.env' do
          Then do  
            assert_file 'roro/containers/database/test.env' do |c| 
              assert_match "POSTGRES_USER=#{env_vars[:postgres_user]}", c
              assert_match "POSTGRES_PASSWORD=#{env_vars[:postgres_password]}", c
              assert_match "POSTGRES_DB=#{env_vars[:app_name] + '_test'}", c
              assert_match "RAILS_ENV=test", c
            end 
          end
        end
      end
    end
  end
end