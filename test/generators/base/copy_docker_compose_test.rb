require_relative "base_test"

describe Roro::CLI do
  get_configuration
      
  Given { cli.copy_docker_compose }
      
  Then do 
    assert_file 'docker-compose.yml' do |c| 
      assert_match("#{env_vars[:app_name]}:", c )
      assert_match("dockerfile: roro/containers/#{env_vars[:app_name]}/Dockerfile", c )
      assert_match("#{env_vars[:app_name]}-data:/usr/src/#{env_vars[:app_name]}", c )
      assert_match("- #{env_vars[:app_name]}", c)
      assert_match("- roro/containers/database/development.env", c)
      assert_match("database:", c)
      assert_match("- database-data:", c)
    end
  end 
end
