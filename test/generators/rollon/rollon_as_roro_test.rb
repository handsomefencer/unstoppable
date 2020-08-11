require "test_helper"
require 'mocha/minitest'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }

  Given(:subject) { Roro::CLI.new }
  Given(:config_for_test) { { use_force: true, interactive: false } }

  Given { subject.get_configuration_variables(config_for_test) } 
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
      Given { skip }
      Then { assert_file "docker-compose.yml" }
    end
    
    describe 'containers' do 
      describe 'app' do 
        
        Then do 
          assert_directory "roro/containers/app/development.env" do |c| 
            assert_match 'DATABASE_HOST=database', c
          end
        end
      end
    end
  end
  
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
end
