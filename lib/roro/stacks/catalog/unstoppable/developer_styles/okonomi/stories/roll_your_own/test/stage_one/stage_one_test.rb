require "test_helper"

describe 'okonomi roll_your_own' do
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[] }
  Given(:workbench)  { 'empty'}

  Given(:rollon)    {
    stub_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given(:adventures) { %w[2 1] }

  Given  { rollon }

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

  describe 'story file' do
    describe 'must have correct content' do
      When(:contents) { [/env/] }
      Then {
        contents.each { |c|
          assert_file 'mise/stacks/my_story/my_story.yml', c }
      }
    end
  end

  describe 'with stage test' do
    Given(:contents) { [
      /describe 'mise stacks my_story'/,

    ] }
    Then  {
      contents.each { |c|
        assert_file 'mise/stacks/my_story/test/stage_one/stage_test.rb', c
    } }
  end
end

