require "test_helper"

describe 'Roro::CLI#rollon' do
  Given(:workbench)  { 'django' }
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { [''] }

  Given(:rollon)    {
    stubs_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  context 'when fatsufodo django' do
    Given(:adventures) { %w[fatsufodo django] }

    Given { quiet { rollon } }

    context 'when default variables' do
      Then  { assert_file 'Dockerfile', /python:3/ }
      And   { assert_file 'docker-compose.yml', /=password/ }
    end

    context 'when overrides variables' do
      When(:overrides) { %w[3.2 y y newpass] }
      Then  { assert_file 'Dockerfile', /python:3.2/ }
      And   { assert_file 'docker-compose.yml', /=newpass/ }
    end
  end
end