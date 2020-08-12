require "test_helper"
require 'mocha/minitest'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }

  Given(:subject) { Roro::CLI.new }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  # Given { asker.stubs(:ask).returns('y') }

  describe '.rollon_as_roro' do 
    describe 'for database vendor' do 
      describe 'postgresql' do 
 
        Given { config_for_test[:database_vendor] = 'postgres'}
        Given { roll_it_on }
        
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
            
          %w(development production test staging ci).each do |env| 
            Then do 
              assert_file( "roro/containers/app/#{env}.env" ) do |c| 
                assert_match( "DATABASE_HOST=#{config[:database_host]}", c ) 
              end
            end
            
            And do 
              assert_file( "roro/containers/database/#{env}.env" ) do |c| 
                assert_match "POSTGRES_USER=#{config[:postgres_user]}", c 
                assert_match "POSTGRES_PASSWORD=#{config[:postgres_password]}", c 
                assert_match "POSTGRES_DB=#{config[:app_name] + "_" + env}", c 
                assert_match "RAILS_ENV=#{env}", c 
              end 
            end
          end
        end
          
        describe 'docker-compose.yml' do
          
          Then do 
            [
              "version: '3.2",
              [
                "  database:",
                "    image: postgres",
                "    env_file:",
                "      - roro/containers/database/development.env",
                "    volumes:",
                "      - db_data:/var/lib/postgresql/data"
              ].join("\n"),
            ].each do |line| 
              assert_file "docker-compose.yml" do |c| 
                assert_match line, c
              end
            end
          end
        end 
      end
      
      describe 'mysql' do 
 
        Given { config_for_test[:database_vendor] = 'mysql'}
        Given { roll_it_on }
 
        describe 'mysql gem in gemfile' do 
      
          Then do 
            assert_file 'Gemfile' do |c| 
              assert_match("gem 'mysql2'", c)
            end
          end
        end
        
        describe 'config/database.yml' do  
          Then do 
            assert_file 'config/database.yml' do |c| 
              assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
              assert_match("<%= ENV.fetch('MYSQL_USER') %>", c)
              assert_match("<%= ENV.fetch('MYSQL_PASSWORD') %>", c)
              assert_match("<%= ENV.fetch('MYSQL_DB') %>", c)
            end
          end
        end
        
        describe 'env_files' do 
            
          %w(development production test staging ci).each do |env| 
            Then do 
              assert_file( "roro/containers/app/#{env}.env" ) do |c| 
                assert_match( "DATABASE_HOST=#{config[:database_host]}", c ) 
              end
            end
            
            And do 
              assert_file( "roro/containers/database/#{env}.env" ) do |c| 
                assert_match "MYSQL_ROOT_PASSWORD=root", c 
                assert_match "MYSQL_PASSWORD=root", c 
                assert_match "MYSQL_DATABASE=#{config[:app_name] + "_" + env}", c 
                assert_match "MYSQL_USERNAME=root", c 
                assert_match "RAILS_ENV=#{env}", c 
              end 
            end
          end
        end

        describe 'docker-compose.yml' do
          
          Then do 
            [
              "version: '3.2",
              [
                "  database:",
                "    image: 'mysql:latest'",
                "    env_file:",
                "      - roro/containers/database/development.env",
                "    volumes:",
                "      - db_data:/var/lib/mysql",
                "    restart: always",
                "    ports:",
                "      - '3307:3306'"
              ].join("\n"),
            ].each do |line| 
              assert_file "docker-compose.yml" do |c| 
                assert_match line, c
              end
            end
          end
        end 
      end
    end

    Given(:config_for_test) { { use_force: true, interactive: false } }

    Given(:config) { subject.get_configuration_variables(config_for_test) }
    Given(:roll_it_on) { config; subject.rollon_as_roro_copy_files }
      
    describe '.rollon_as_roro_copy_files' do 
      Given { skip }
      Given { roll_it_on }    
      
      describe 'copies' do 
        describe 'dotfiles' do 
          
          Then { assert_file ".dockerignore" }
        end
        
        describe 'directories' do 

          Then { assert_directory "roro" }
          And  { assert_directory "roro/containers" }
          And  { assert_directory "roro/containers/app" } 
          And  { assert_directory "roro/containers/database" } 
          And  { assert_directory "roro/containers/frontend" } 
        end
        
        describe 'containers' do 
          describe 'app' do 
            describe 'Dockerfile' do 
              
              Given(:expected) { [
                "FROM ruby:#{config[:ruby_version]}",
                "maintainer=\"#{config[:dockerhub_email]}" ] }
    
              Then do 
                expected.each do |line|
                  assert_file "roro/containers/app/Dockerfile" do |c| 
                    assert_match line, c
                  end
                end
              end
            end
          end 
        end
      end 
    end 
  end
end    

