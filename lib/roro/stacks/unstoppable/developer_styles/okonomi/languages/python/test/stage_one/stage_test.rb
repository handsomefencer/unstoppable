require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles okonomi languages python' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[] }

  Given(:rollon)     {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__)
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { skip }

  Given { quiet { rollon } }

  describe 'must generate a' do
    describe '.keep file ' do
      Then  { assert_file '.keep' }
    end
  end
end