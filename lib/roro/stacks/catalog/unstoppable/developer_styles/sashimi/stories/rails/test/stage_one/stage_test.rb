require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles sashimi stories rails' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    stub_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { rollon unless adventures.empty?}

  context 'when default variables interpolated' do
    Then  { assert_file "lib/roro/stacks/catalog/unstoppable/developer_styles/sashimi/stories/rails/rails.yml", /env/ }
  end

  context 'when many items interpolated' do
    Given(:contents) { [:env, :preface, :actions] }
    Then {
      contents.each { |c|
        assert_file "lib/roro/stacks/catalog/unstoppable/developer_styles/sashimi/stories/rails", c
      }
    }
  end
end
