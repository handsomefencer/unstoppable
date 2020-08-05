require "test_helper"


describe Roro::CLI do
  
  Given(:cli) { Roro::CLI.new }
  
  Given { prepare_destination 'dummy' }
  
  Given(:configurable_env_vars) { {
    "APP_NAME"=>"dummy", 
    "RUBY_VERSION"=> /\.\d/, 
    "SERVER_HOST"=>"ip-address-of-your-server", 
    "DOCKERHUB_EMAIL"=>"your-docker-hub-email",
    "DOCKERHUB_USER"=>"your-docker-hub-user-name", 
    "DOCKERHUB_ORG"=>"your-docker-hub-org-name", 
    "DOCKERHUB_PASS"=>"your-docker-hub-password", 
    "POSTGRES_USER"=>"postgres", 
    "POSTGRES_PASSWORD"=>"your-postgres-password"} }
  
  Given(:env_vars) { configurable_env_vars.merge(     
      "DEPLOY_TAG"=>"${CIRCLE_SHA1:0:7}", 
      "SERVER_PORT"=>"22", 
      "SERVER_USER"=>"root" ) } 
    
  describe '.set_from_defaults' do 
 
    Given(:config) { cli.set_from_defaults }
 
    Then { configurable_env_vars.each { |k,v| assert_match v, config[k] } } 
  end
  
  describe ".get_configuration_variables" do
    
    Given(:config) { cli.get_configuration_variables } 
    
    Given { env_vars.merge(     
      "DEPLOY_TAG"=>"${CIRCLE_SHA1:0:7}", 
      "SERVER_PORT"=>"22", 
      "SERVER_USER"=>"root" ) } 

    Then { env_vars.each { |key,value| assert_match value, config[key] } }
  end 
  
  describe 'methods' do 
      
    # Given { cli.get_configuration_variables }
 
    describe '.copy_docker_compose' do 
      
      Given { cli.copy_docker_compose }
      
      Then { assert_file 'docker-compose.yml' }
    end 

    describe ".config_std_out" do 
      
      Given { cli.config_std_out_true }
      
      Then do assert_file 'config/boot.rb' do |c| 
          assert_match("$stdout.sync = true", c )
        end
      end
      
    end
    
    describe '.gitignore_sensitive_files' do 
      
      Given { cli.gitignore_sensitive_files }
      
      Then do 
        assert_file '.gitignore' do |c|
          assert_match /roro\/\*\*\/\*.key/, c
          assert_match /roro\/\*\*\/\*.env/, c
        end
      end
    end
    
    describe '.copy_circleci' do 
      
      Given { cli.copy_circleci }
      
      Then do 
        assert_directory '.circleci' 
        assert_file '.circleci/config.yml' 
      end
    end
    
    describe '.copy_roro' do 
      
      Given { cli.copy_roro }
      
      Then do 
        assert_directory 'roro' 
        assert_directory 'roro/containers' 
      end
    end
    
    describe '.insert_roro_gem_into_gemfile' do 
      
      Given { cli.insert_roro_gem_into_gemfile }
      
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'roro'\n\n", c)
        end
      end
    end

    describe '.insert_hfci_gem_into_gemfile' do 
      
      Given { cli.insert_hfci_gem_into_gemfile }
      
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'handsome_fencer-test'", c)
        end
      end
    end

    describe '.copy_config_database_yml' do 
      
      Given { cli.copy_config_database_yml }
      
      Then do 
        assert_file 'config/database.yml' do |c| 
          assert_match("<%= ENV.fetch('DATABASE_HOST') %>", c)
        end
      end
    end
  end
end
