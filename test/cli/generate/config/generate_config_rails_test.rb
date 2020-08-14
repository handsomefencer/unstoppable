require "test_helper"

describe Roro::CLI do
  
  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination "rails/603" }
  Given { skip }
  describe "generate:config:rails" do

    Given { subject.generate_config_rails }

    Then do 
      assert_file '.roro.yml' do |c| 
        assert_match '603', c
      end 
    end
  end
end
