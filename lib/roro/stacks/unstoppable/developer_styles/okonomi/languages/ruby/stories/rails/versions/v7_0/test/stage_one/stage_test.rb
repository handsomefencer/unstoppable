require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles okonomi languages ruby stories rails versions 7_0' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[ okonomi ruby rails 7_0 ] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_dependencies_met?
    stubs_yes?
    stubs_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { quiet { rollon } }

  describe 'must generate a' do
    describe 'Gemfile with the correct rails version' do
      Then  { assert_file 'Gemfile', /gem \"rails\", \"~> 7.0.0.alpha2/ }
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        Then  { assert_file 'Dockerfile', /FROM ruby:3.0/ }
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end
  end
end