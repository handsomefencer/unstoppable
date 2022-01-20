require 'test_helper'

describe "#{adventure_name(__FILE__)}" do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__)
    stubs_dependencies_met?
    stubs_yes?
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  # Given { quiet { rollon } }
  Given {  rollon }

  describe 'must generate a' do
    describe 'Gemfile with the correct rails version' do
      Then  { assert_file 'Gemfile', /gem \"rails\", \"~> 7.0.1/ }
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        Then  { assert_file 'Dockerfile', /FROM ruby:2.7/ }
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end
  end
end