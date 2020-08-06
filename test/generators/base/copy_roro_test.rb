require_relative "base_test"

describe Roro::CLI do
  
  get_configuration
      
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
          Given { skip }
          Then do  
            assert_file "roro/containers/app/development.env" do |c| 
              assert_match "DATABASE_HOST=#{env_vars[:database_container]}", c
            end 
          end
        end
        
        describe 'test.env' do
          Given { skip }
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
