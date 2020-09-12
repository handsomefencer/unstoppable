require 'test_helper'

describe Roro::CLI do
  
  Given { rollon_rails_test_base }

  Given(:config) { Roro::Configuration.new }
  Given(:cli)    { Roro::CLI.new }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.rollon_rails }

  describe '.rollon with postgresql' do 

    Given { rollon }

    describe 'pg gem in gemfile' do 
  
      Given(:file) { 'Gemfile' }
      Given(:insertion) { "gem 'pg'" }
      
      Then { assert_insertion }
    end
  end
end
