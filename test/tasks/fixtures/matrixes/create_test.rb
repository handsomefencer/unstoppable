# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake fixtures:matrixes:create' do
  Given(:matrixes_path) { 'test/fixtures/matrixes' }
  Given(:workbench)     { matrixes_path }
  Given(:file)          { "#{matrixes_path}/#{matrix}.yml" }
  Given(:cases)         { read_yaml("#{Dir.pwd}/#{file}") }

  describe ':cases' do
    Given(:matrix) { 'cases' }

    describe 'when task has not run' do
      Then { refute_file file }
    end

    describe 'when task is run' do
      Given { run_task("fixtures:matrixes:create:#{matrix}" ) }
      Then  { assert_file file }
      And   { assert_match 'Creating', @output.first }
      And   { assert_match 'Created', @output.first }
      And   { assert_equal 33, cases.size }
      And   { assert_equal [1,1], cases.first }
      And   { assert_equal [3,1,2,1], cases[8] }
      And   { assert_equal [3,2,1,1,2,2,1], cases[18] }
    end
  end

  describe ':itineraries' do
    Given(:matrix) { 'itineraries' }

    describe 'when task has not run' do
      Then { refute_file file }
    end

    describe 'when task is run' do
      Given { run_task("fixtures:matrixes:create:#{matrix}" ) }
      Then  { assert_file file }
      And   { assert_match 'Creating', @output.first }
      And   { assert_match 'Created', @output.first }
      And   { assert_equal 33, cases.size }
      # And   { assert_equal [1,1], cases.first }
      # And   { assert_equal [3,1,2,1], cases[8] }
      # And   { assert_equal [3,2,1,1,2,2,1], cases[18] }
    end
  end
end
