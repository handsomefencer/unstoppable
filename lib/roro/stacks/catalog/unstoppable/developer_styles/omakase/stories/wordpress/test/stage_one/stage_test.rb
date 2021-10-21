require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles omakase stories wordpress' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[] }
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

  context 'when default variables interpolated' do
    Then  { assert_file "lib/roro/stacks/catalog/unstoppable/developer_styles/omakase/stories/wordpress/wordpress.yml", /env/ }
  end

  context 'when many items interpolated' do
    Given(:contents) { [:env, :preface, :actions] }
    Then {
      contents.each { |c|
        assert_file "lib/roro/stacks/catalog/unstoppable/developer_styles/omakase/stories/wordpress", c
      }
    }
  end
end
