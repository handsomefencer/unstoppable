require 'test_helper'

describe 'okonomi ruby rails 7_0' do
  Given(:workbench) { 'empty' }
  Given(:cli)       { Roro::CLI.new }
  Given(:overrides) { %w[] }
  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__)
    stubs_dependencies_met?
    stubs_yes?
    stub_overrides
    stub_run_actions
    cli.rollon
  }
  Given { skip }
  Given { quiet { rollon } }

  describe 'must generate a' do
    describe 'Dockerfile' do
      Given(:variant) { [4, 1] }
      describe 'ruby version' do
        Then  { assert_file 'Dockerfile', /FROM ruby:2.7.4-alpine/ }
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end
  end
end