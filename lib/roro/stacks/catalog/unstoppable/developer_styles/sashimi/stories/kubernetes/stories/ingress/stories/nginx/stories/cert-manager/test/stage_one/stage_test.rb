
require 'test_helper'

describe 'kubernetes ingress nginx cert-manager' do
  Given { skip }
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[5 1] }
  Given(:overrides)  { %w[4 1] }

  Given(:rollon)    {
    stub_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { rollon unless adventures.empty?}

  context 'when default variables interpolated' do
    Then  { assert_file "lib/roro" }
  end

  context 'when many items interpolated' do
    Given(:contents) { [:env, :preface, :actions] }
    Then {
      contents.each { |c|
        assert_file "lib/roro/stacks", c
      }
    }
  end
end
