require "test_helper"

describe Roro::CLI do
  
  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination "rails/603" }
  describe "generate:config:rails" do

    Given { subject.generate_config_rails }

    Then do 
      assert_file '.roro_config.yml' do |c| 
        assert_match 'your-project-name', c
      end 
    end
  end
end
