require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config) { Roro::Configurator.new }
  Given(:cli){ Roro::CLI.new }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.rollon_rails }

  describe '.rollon with postgresql' do 

    Given { config.intentions['configure_database'] = 'p' }

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
