require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles okonomi languages ruby stories rails versions 7_0' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[ 2 2 1 1 ] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    stubs_dependency_met?(:git)
    stubs_yes?
    stub_adventure
    stub_overrides
    stub_run_actions
    # quiet { cli.rollon }
    cli.rollon
  }

  Given { rollon unless adventures.empty?}

  describe 'must generate a' do
    describe 'Gemfile with the correct rails version' do


      Then  { assert_file 'Gemfile', /'rails', '~>7.0.0.alpha2'/ }

    end

    describe 'a file in the adjacent templates directory' do
     # Then  { assert_file 'Dockerfile' }

      describe 'with expected content matching regex' do
        # Then  { assert_file 'Dockerfile', /FROM ruby:3.0/ }
      end

      describe 'with expected content the same as actual content string' do
#       Then  { assert_file 'path_to_expected_file', 'expected_content' }
      end

      describe 'with many strings expected to have been interpolated' do

#        Given(:strings) { [1, :second, third] }
#        Then { strings.each { |c| assert_file 'path_to_expected_file', c }
      end
    end
  end
end