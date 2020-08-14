require_relative "base_test"

describe Roro::CLI do
  Given { skip }
  get_configuration
      
  describe '.copy_circleci' do 
    
    Given { cli.copy_circleci }
    
    Then do 
      assert_directory '.circleci' 
      assert_file '.circleci/config.yml' do |c| 
        assert_match "machine: true", c
        assert_match "- run: docker-compose up -d #{env_vars[:app_name]} --build", c
      end
    end
  end
end
