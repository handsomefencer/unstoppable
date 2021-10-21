require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles omakase stories wordpress' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[3 2] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    ## Answers adventure questions according to values set in the :adventures array.
    stub_adventure
    ## Answers environment variable questions according to values set in
    #  the overrides array. Defaults to 'y'.
    stub_overrides
    ## Ensures Thor run commands are stubbed.
    stub_run_actions
    cli.rollon
    ## To quiet the test output do:
    # quiet { cli.rollon }
  }

  ## Tests will hang if the :adventures array is empty.
  Given { rollon unless adventures.empty?}

  describe 'must have docker-compose.yml file' do
    Then  { assert_file 'docker-compose.yml' }
  end

  describe 'must have a mise en place' do
    Then  { assert_file 'mise/mise.roro' }
  end

  describe 'must have correct containers' do
    Then  { assert_file 'mise/containers/wordpress' }
  end

  describe 'must have correct variables in files' do
    Then  { assert_file 'mise/env/base.env', /WORDPRESS_IMAGE=wordpress/ }
  end
end
