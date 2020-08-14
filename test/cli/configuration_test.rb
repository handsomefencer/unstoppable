require "test_helper"

describe Roro::Configuration do
  
  Given { prepare_destination "rails/603" }
  
  env_vars = {
    app_name: '603', 
    ruby_version: `ruby -v`.scan(/\d.\d/).first.to_s,
    deployment_image_tag: "${CIRCLE_SHA1:0:7}", 
    dockerhub_email: "your-docker-hub-email",
    dockerhub_org: "your-docker-hub-org-name", 
    dockerhub_user: "your-docker-hub-user-name", 
    dockerhub_password: "your-docker-hub-password", 
    database_service: 'database',
    database_vendor: 'postgresql',
    frontend_container: 'frontend',
    webserver_service: 'nginx',
    # postgres_user: "postgres",
    postgresql_env_vars: {
      'POSTGRES_USER' => 'postgres',           
      'POSTGRES_PASSWORD'  => 'your-postgres-password'
    },
    mysql_env_vars: {
      'MYSQL_ROOT_PASSWORD' => 'root', 
        'MYSQL_PASSWORD' => 'root',
        'MYSQL_USERNAME' => 'root',
        'MYSQL_DATABASE' => 'myapp_db',
        'MYSQL_DATABASE_PORT' => '3306'
    }
  }
    
  Given(:config) { Roro::Configuration.new }
  
  Given { config }

  describe '.master' do 

    Then { assert_equal Hash, config.master.class }
  end

  describe '.app' do 
    
    Then { assert_equal Hash, config.app.class}  
  end
  
  describe '.set_from_defaults' do 
    
    Given { config.set_from_defaults }

    env_vars.each do |key, value| 
  
      describe "key ':#{key}' must return value '#{value}' " do 
        
        Then do 
          assert_equal value, config.app[key]          
        end
        
      end
    end
  end
  
  describe '.choices' do 
    describe 'must have question, choices, and default keys' do 
   
      Given(:questions) { config.choices } 
      
      Then do 
        questions.each do |key, value| 
          assert_equal value.keys, %w(question choices default)
          assert_equal value['choices'].class, Hash
          assert_equal value['default'].class, String
        end 
      end
    end
  end
end  
