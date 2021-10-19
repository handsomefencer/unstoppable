require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles fatsufodo stories flask' do
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
    quiet { cli.rollon }
  }

  Given { rollon }

  context 'when default variables' do
    Then  { assert_file 'my_story/my_story.yml', /env/ }
  end

  context 'when overriden variables' do
    Given(:overrides) { ['other_story'] }
    Then  { assert_file 'other_story/other_story.yml', /env/ }
  end

  context 'when many interpolations' do
    Given(:contents) { [:env, :preface, :actions] }
    Then {
      contents.each { |c|
        assert_file 'my_story/test/stage_one/stage_test.rb', c
      }
    }
  end
end