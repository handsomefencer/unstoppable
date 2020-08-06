require_relative "base_test"

describe Roro::CLI do
  
  get_configuration
    
  describe '.copy_config_database_yml' do 
      
    Given { cli.copy_config_database_yml }
    
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
