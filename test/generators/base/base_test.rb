require "test_helper"

class Minitest::Spec

  def self.get_configuration
    Given(:rails_version) { '603'}
    Given(:configurable_env_vars) { {
      app_name: rails_version, 
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
      postgres_password: "your-postgres-password"} }
      
      Given(:env_vars) { configurable_env_vars.merge(     
        deploy_tag: "${CIRCLE_SHA1:0:7}", 
        server_port: "22", 
        server_user: "root" ) }
        
    Given { prepare_destination "rails/#{rails_version}" }
    Given(:cli) { Roro::CLI.new }
    Given { cli.get_configuration_variables } 
  end
end

