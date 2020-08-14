require_relative "base_test"

describe Roro::CLI do
  
  Given { prepare_destination "rails/603" }
  
  Given(:configurable_env_vars) { {
    app_name: 603, 
    ruby_version: `ruby -v`.scan(/\d.\d/).first, 
    server_host: "ip-address-of-your-server", 
    dockerhub_email: "your-docker-hub-email",
    dockerhub_user: "your-docker-hub-user-name", 
    dockerhub_org: "your-docker-hub-org-name", 
    dockerhub_password: "your-docker-hub-password", 
    database_container: 'database',
    frontend_container: 'frontend',
    server_container: 'nginx',
    postgres_user: "postgres", 
    postgres_password: "some-long-secure-password"} }
    
  Given(:env_vars) { configurable_env_vars.merge(     
    deploy_tag: "${CIRCLE_SHA1:0:7}", 
    server_port: "22", 
    server_user: "root" ) }
      
  Given(:cli) { Roro::CLI.new }
      
  describe '.set_from_defaults' do 
    # Given()
    # Given(:config) { cli.set_from_defaults }
    Given(:config) { cli.set_from_defaults }
 Then { assert_equal config, 'blah'}
    # Given { byebug }
    # Then { configurable_env_vars.each { |k,v| assert_match v, config[k] } } 
    
    # Then { assert_file '.roro.yml' }

  end
end
