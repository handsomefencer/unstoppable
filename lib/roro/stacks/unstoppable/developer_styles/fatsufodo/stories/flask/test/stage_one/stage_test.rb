require 'test_helper'

describe 'fatsufodo flask' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[ fatsufodo flask ] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    stubs_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { quiet { rollon } }

  context 'when default variables interpolated' do
    Then  { assert_file "app.py", /import time/ }
  end
end
