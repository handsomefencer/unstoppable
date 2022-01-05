require "test_helper"

describe 'okonomi roll_your_own' do
  Given(:cli)       { Roro::CLI.new }
  Given(:overrides) { %w[] }
  Given(:workbench) { 'empty'}
  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__)
    stub_overrides
    stub_run_actions
    cli.rollon
  }
  Given { skip }
  Given { quiet { rollon } }
  # Given { skip }
  describe 'must generate' do
    describe 'templates with stage one' do
      Then  { assert_file 'mise/stacks/my_story/templates/stage_one/.keep' }
    end

    describe 'test' do
      describe 'with stage one' do
        describe 'with stage dummy' do
          Then  { assert_file 'mise/stacks/my_story/test/stage_one/stage_dummy/.keep' }
        end
      end
    end
  end

  describe 'story file must have correct content' do
    When(:contents) { [/env/] }
    Then { contents.each { |c|
      assert_file 'mise/stacks/my_story/my_story.yml', c } }
  end

  describe 'must generate mise' do
    Then { assert_file 'mise' }
  end

  describe 'must generate containers' do
    Then { assert_file 'mise/containers' }
  end

  describe 'must generate environments' do
    Then { assert_file 'mise/env/base.env' }
  end

  describe 'must generate keys' do
    Then { assert_file 'mise/keys/base.key' }
  end
end

