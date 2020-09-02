require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config) { Roro::Configuration.new }
  Given(:subject){ Roro::CLI.new }
  Given(:rollon) { 
    subject.instance_variable_set(:@config, config)
    subject.rollon_rails }

  describe '.rollon with postgresql' do 

    Given { config.thor_actions['configure_database'] = 'p' }

    Given { rollon }

    describe 'pg gem in gemfile' do 
  
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'pg'", c)
        end
      end
    end
  end
end
