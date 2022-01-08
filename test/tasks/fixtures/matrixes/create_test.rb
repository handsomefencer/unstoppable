# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake fixtures:matrixes:create' do
  Given(:matrixes_path) { 'test/fixtures/matrixes' }
  Given(:workbench)     { matrixes_path }
  Given(:file)          { "#{matrixes_path}/#{matrix}.yml" }
  Given(:content)       { read_yaml("#{Dir.pwd}/#{file}") }

  describe ':cases' do
    Given(:matrix)  { 'cases' }
    Given(:execute) { capture_subprocess_io {
      Rake::Task['fixtures:generate:cases'].execute
    }}

    context 'when task has not run' do
      Then { refute_file file }
    end

    context 'when task is run' do
      describe 'must create cases file'do
        Given { execute }
        Then  { assert_file file }
      end

      describe 'must provide cli output' do
        Then { assert_match 'Creating', execute.first }
        And  { assert_match 'Created', execute.first }
      end

      describe 'must return correct' do
        Given { execute }

        describe 'number of cases' do
          Then  { assert_equal 33, content.size }
        end

        describe 'simple case' do
          Then { assert_equal [1,1], content.first }
        end

        describe 'intermediate case' do
          Then { assert_equal [3,1,2,1], content[8] }
        end

        describe 'advanced case' do
          Then { assert_equal [3,2,1,1,2,2,1], content[18] }
        end
      end
    end
  end

  # describe ':itineraries' do
  #   Given(:matrix) { 'itineraries' }
  #
  #   describe 'when task has not run' do
  #     Then { refute_file file }
  #   end
  #
  #   describe 'when task is run' do
  #     Given { run_task("fixtures:generate" ) }
  #     Then  { assert_file file }
  #     # And   { assert_match 'Creating', @output.first }
  #     # And   { assert_match 'Created', @output.first }
  #     # And   { assert_equal 33, content.size }
  #     # And   { assert_equal [1,1], content.first }
  #     # And   { assert_equal [3,1,2,1], content[8] }
  #     # And   { assert_equal [3,2,1,1,2,2,1], content[18] }
  #   end
  # end
end
