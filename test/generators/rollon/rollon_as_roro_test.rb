require "test_helper"
require 'mocha/minitest'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }

  Given(:subject) { Roro::CLI.new }
  Given(:config_for_test) { { use_force: true, interactive: false } }

  Given(:config) { subject.get_configuration_variables(config_for_test) }
  Given { config } 
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given { subject.rollon_as_roro  }

  describe 'copies' do 
    
    Then { assert_directory "roro" }
    And  { assert_directory "roro/containers" }
    And  { assert_directory "roro/containers/app" } 
    And  { assert_directory "roro/containers/database" } 
    And  { assert_directory "roro/containers/frontend" } 

    describe 'dotfiles' do 
      
      Then { assert_file ".dockerignore" }
    end
    
    describe 'docker-compose.yml' do 
      Given { config[:database_vendor] = 'postgres'}
      Given(:expected) { [
        "version: '3.2",
        [
          "  database:",
          "    image: postgres",
          "    env_file:",
          "      - roro/containers/database/development.env",
          "    volumes:",
          "      - db_data:/var/lib/postgresql/data"
        ].join("\n"),
      ] }

      Then do 
        expected.each do |line|
          assert_file "docker-compose.yml" do |c| 
            assert_match line, c
          end
        end
      end
    end
    
    describe 'containers' do 
      describe 'app' do 
        describe 'env' do 
          
          Then do 
            %w(development production test staging ci).each do |env| 
              assert_file( "roro/containers/app/#{env}.env" ) do |c| 
                assert_match( "DATABASE_HOST=#{config[:database_host]}", c ) 
              end
            end
          end
        end
        
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
      
      describe 'database' do
        describe 'env' do

          Then do 
            %w(development production test staging ci).each do |env| 
              assert_file( "roro/containers/database/#{env}.env" ) do |c| 
                assert_match "POSTGRES_USER=#{config[:postgres_user]}", c 
                assert_match "POSTGRES_PASSWORD=#{config[:postgres_password]}", c 
                assert_match "POSTGRES_DB=#{config[:app_name] + "_" + env}", c 
                assert_match "RAILS_ENV=#{env}", c 
              end
            end
          end
        end
      end
    end
  end 
end

# assert_file 'config/database.yml' do |c|
  # assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
  # assert_match("<%= ENV.fetch('POSTGRES_USER') %>", c)
  # assert_match("<%= ENV.fetch('POSTGRES_PASSWORD') %>", c)
  # assert_match("<%= ENV.fetch('POSTGRES_DB') %>", c)
# end
# hen do
#   # database:\n    image: postgres\n    env_file:\n      - .env/development/database\n
#       # volumes:\n      - db_data:/var/lib/postgresql/data\n\n  
#   expected = [
    
    
#     "database:",
#     "    image: postgres",
#     "    env_file:",
#     "      - .env/development/database",
#     "    volumes:",
#     "      - db_data:/var/lib/postgresql/data"
#   ].join("\n")
#   assert_file "docker-compose.yml" do |c| 
#     assert_match expected, c 
#     # assert_match '\timage: postgres', c 
#     # image: postgres
# # env_file:
# #   - .env/development/database
# # volumes:
# #   - db_data:/var/lib/postgresql/data

    
  # describe 'docker-compose.yml' do
  #   describe 'postgres service' do 
  #     Then do
  #       # database:\n    image: postgres\n    env_file:\n      - .env/development/database\n
  #           # volumes:\n      - db_data:/var/lib/postgresql/data\n\n  
  #       expected = [
          
          
  #         "database:",
  #         "    image: postgres",
  #         "    env_file:",
  #         "      - .env/development/database",
  #         "    volumes:",
  #         "      - db_data:/var/lib/postgresql/data"
  #       ].join("\n")
  #       assert_file "docker-compose.yml" do |c| 
  #         assert_match expected, c 
  #         # assert_match '\timage: postgres', c 
  #         # image: postgres
  #     # env_file:
  #     #   - .env/development/database
  #     # volumes:
  #     #   - db_data:/var/lib/postgresql/data
   
  #       end
  
  #     end
      
  #   end
  # end
  
  # describe "configure db" do 
  #   Given { skip }
  #   Then do 
  #     assert_file 'config/database.yml' do |c|
  #       assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
  #       assert_match("<%= ENV.fetch('POSTGRES_USER') %>", c)
  #       assert_match("<%= ENV.fetch('POSTGRES_PASSWORD') %>", c)
  #       assert_match("<%= ENV.fetch('POSTGRES_DB') %>", c)
  #     end
  #   end
  # end
# end
