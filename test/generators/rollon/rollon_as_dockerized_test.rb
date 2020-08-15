require "test_helper"
require 'mocha/minitest'

describe Roro::CLI do
Given { skip }
  Given { prepare_destination 'rails/603' }

  Given(:subject) { Roro::CLI.new }
  Given(:config_for_test) { { use_force: true, interactive: false } }

  Given { subject.get_configuration_variables(config_for_test) } 
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given { subject.rollon_dockerize_files  }

  describe 'copies' do 
    
    Then do 
      assert_file ".env/development/database" 
      assert_file ".env/development/web"
      assert_file "Dockerfile" 
      assert_file "docker-entrypoint.sh"
      assert_file ".dockerignore"
    end
  end
  
  describe 'docker-compose.yml' do
    describe 'postgres service' do 
      Then do
        expected = [
          "database:",
          "    image: postgres",
          "    env_file:",
          "      - .env/development/database",
          "    volumes:",
          "      - db_data:/var/lib/postgresql/data"
        ].join("\n")
        assert_file "docker-compose.yml" do |c| 
          assert_match expected, c 
        end
      end
    end
  end
  
  describe "configure db" do 
    
    Then do 
      assert_file 'config/database.yml' do |c|
        assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
        assert_match("<%= ENV.fetch('POSTGRES_USER') %>", c)
        assert_match("<%= ENV.fetch('POSTGRES_PASSWORD') %>", c)
        assert_match("<%= ENV.fetch('POSTGRES_DB') %>", c)
      end
    end
  end
end
