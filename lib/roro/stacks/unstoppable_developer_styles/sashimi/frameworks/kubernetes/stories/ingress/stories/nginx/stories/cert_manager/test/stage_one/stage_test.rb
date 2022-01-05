require 'test_helper'

describe 'sashimi kubernetes ingress nginx cert-manager' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[4 1] }

  Given(:rollon)    {
    stubs_adventure(__dir__)
    stub_overrides
    stub_run_actions
    cli.rollon
  }
  Given { skip }

  Given { quiet { rollon } }

  context 'when default variables interpolated' do
    Then  { assert_file "echo1.yaml" }
  end
end
