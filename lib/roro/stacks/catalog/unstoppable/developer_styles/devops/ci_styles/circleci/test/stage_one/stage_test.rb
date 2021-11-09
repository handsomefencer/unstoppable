require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles devops ci_styles circleci circleci' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[1 1] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    stub_adventure
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { rollon unless adventures.empty?}

  describe 'must generate a' do
    describe 'k8s directory' do
      Then  { assert_file '.keep' }
    end
    describe '.keep file so Git keeps the directory under source control' do
      Then  { assert_file '.keep' }
    end

    describe 'a file in the adjacent templates directory' do
#      Then  { assert_file 'path_to_expected_file' }

      describe 'with expected content matching regex' do
#       Then  { assert_file 'path_to_expected_file', /expected_content' }
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