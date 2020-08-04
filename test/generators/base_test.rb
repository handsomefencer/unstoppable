require "test_helper"


describe Roro::CLI do
  
  Given(:cli) { Roro::CLI.new }
  
  Given { prepare_destination 'dummy' }
  
  Given(:env_vars) { {
    "APP_NAME"=>"dummy", 
    "RUBY_VERSION"=> /\.\d/, 
    "SERVER_HOST"=>"ip-address-of-your-server", 
    "DOCKERHUB_EMAIL"=>"your-docker-hub-email",
    "DOCKERHUB_USER"=>"your-docker-hub-user-name", 
    "DOCKERHUB_ORG"=>"your-docker-hub-org-name", 
    "DOCKERHUB_PASS"=>"your-docker-hub-password", 
    "POSTGRES_USER"=>"postgres", 
    "POSTGRES_PASSWORD"=>"your-postgres-password"} }
  
  describe "without interactivity" do
    describe ".set_from_defaults" do 
    
      Given(:config) { cli.set_from_defaults } 

      Then { env_vars.each { |key,value| assert_match value, config[key] } }
    end

    describe ".get_configuration_variables" do
      
      Given(:config) { cli.get_configuration_variables } 
      Given { env_vars.merge(     
        "DEPLOY_TAG"=>"${CIRCLE_SHA1:0:7}", 
        "SERVER_PORT"=>"22", 
        "SERVER_USER"=>"root" ) } 
 
      Then { env_vars.each { |key,value| assert_match value, config[key] } }
    end
  end 
  
  describe '.copy_base_files' do 
    describe '.copy_docker_compose' do 
    
      Given { cli.copy_docker_compose }
      
      Then { assert_file 'docker-compose.yml' }
    end
    
    describe '.modify_gitignore' do 
      Given { cli.modify_gitignore }
      
      Then { assert_file '.gitignore' }
      
    end
    
    # def copy_docker_compose
    #   get_configuration_variables
    #   copy_base_files
    # end
    

    Then {
      # assert_file 'Gemfile', /gem \'pg\'/
    #   assert_file 'Gemfile', /gem \'sshkit\'/
    #   assert_file 'Guardfile'
    #   assert_file '.gitignore', /docker\/\*\*\/\*.key/
    #   assert_file '.gitignore', /docker\/\*\*\/\*.env/

    #   assert_file 'roro'
    }
  end
end
