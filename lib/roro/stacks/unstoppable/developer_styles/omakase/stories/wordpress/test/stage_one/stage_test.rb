require 'test_helper'

describe 'omakase wordpress' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[omakase wordpress] }
  Given(:overrides)  { [''] }
  Given(:rollon)    {
    stubs_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { quiet { rollon } unless adventures.empty?}

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
