require "test_helper"

describe Roro::CLI do
  
  Given(:cli) { Roro::CLI.new }
  
  Given { prepare_destination 'dummy' }
  
  Given(:configurable_env_vars) { {
    app_name: "dummy", 
    ruby_version:`ruby -v`.scan(/\d.\d/).first, 
    server_host: "ip-address-of-your-server", 
    dockerhub_email: "your-docker-hub-email",
    dockerhub_user: "your-docker-hub-user-name", 
    dockerhub_org: "your-docker-hub-org-name", 
    dockerhub_password: "your-docker-hub-password", 
    database_container: 'database',
    frontend_container: 'frontend',
    server_container: 'nginx',
    postgres_user: "postgres", 
    postgres_password: "your-postgres-password"} }
 
  Given(:env_vars) { configurable_env_vars.merge(     
    deploy_tag: "${CIRCLE_SHA1:0:7}", 
    server_port: "22", 
    server_user: "root" ) } 
    
  describe '.set_from_defaults' do 
 
    Given(:config) { cli.set_from_defaults }
 
    Then { configurable_env_vars.each { |k,v| assert_match v, config[k] } } 
  end
  
  describe ".get_configuration_variables" do
    
    Given(:config) { cli.get_configuration_variables } 
    
    Given { env_vars.merge(     
      deploy_tag: "${CIRCLE_SHA1:0:7}", 
      server_port: "22", 
      server_user: "root" ) } 

    Then { env_vars.each { |key,value| assert_match value, config[key] } }
  end 
  
  describe 'methods' do 
    Given { cli.get_configuration_variables }
    describe '.copy_docker_compose' do 
      
      Given { cli.copy_docker_compose }
      
      Then do 
        assert_file 'docker-compose.yml' do |c| 
          assert_match("#{env_vars[:app_name]}:", c )
          assert_match("dockerfile: docker/containers/#{env_vars[:app_name]}/Dockerfile", c )
          assert_match("#{env_vars[:app_name]}-data:/usr/src/#{env_vars[:app_name]}", c )
          assert_match("- #{env_vars[:app_name]}", c)
          assert_match("- docker/containers/database/development.env", c)
          assert_match("database:", c)
          assert_match("- database-data:", c)
        end
      end 
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
      
      describe 'containers' do 
        describe 'app_name' do 
          describe 'Dockerfile' do 
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
              assert_file 'roro/containers/app/development.env' do |c| 
                assert_match "DATABASE_HOST=#{env_vars[:database_container]}", c
              end 
            end
          end
          
          describe 'test.env' do
            Then do  
              assert_file 'roro/containers/app/test.env' do |c| 
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
