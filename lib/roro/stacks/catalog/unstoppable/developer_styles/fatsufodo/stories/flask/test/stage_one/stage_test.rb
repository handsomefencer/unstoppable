require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles fatsufodo stories flask' do
  Given { skip }
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[1 3] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    ## Answers adventure questions according to values set in the :adventures array.
    stub_adventure
    ## Answers environment variable questions according to values set in
    #  the overrides array. Defaults to 'y'.
    stub_overrides
    ## Ensures Thor run commands are stubbed.
    stub_run_actions
    ## Tests will hang with an empty adventures array.
    # cli.rollon
    ## To quiet the test output do:
    quiet { cli.rollon }
  }

  Given { rollon unless adventures.empty?}

  context 'when default variables interpolated' do
    Then  { assert_file "app.py", /import time/ }
  end

  context 'when many items interpolated' do
    # Given(:contents) { [:env, :preface, :actions] }
    # Then {
    #   contents.each { |c|
    #     assert_file "lib/roro/stacks/catalog/unstoppable/developer_styles/fatsufodo/stories/flask", c
    #   }
    # }
  end
end
