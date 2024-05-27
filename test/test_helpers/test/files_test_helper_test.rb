# frozen_string_literal: true

require 'test_helper'

describe 'Roro::TestHelpers::FilesTestHelper' do
  describe '#glob_dir(regex)' do
    Given(:workbench) { 'crypto' }
    Given(:expected) { /entrypoint.sh/ }
    Given(:regex) { "**/*.sh" }
    Given(:path) { 'crypto/roro'}
    Given(:result) { glob_dir(regex, path).first }

    describe 'when directory is empty' do
      Given(:workbench) {  }
      Then { assert_empty glob_dir }
    end

    describe 'when directory is not empty' do
      Then { refute_empty glob_dir }
    end

    describe 'when regex is custom and no path specified' do
      Then { assert_match expected, glob_dir(regex).first }
    end

    describe 'when regex is custom and file is in specified path' do
      Given(:path) { 'crypto/roro'}
      Then { assert_match expected, result }
    end

    describe 'when regex is custom but file is not in specified path' do
      Given(:path) { 'crypto/roro/scripts'}
      Then { assert_nil result }
    end

  end
  describe '#use_fixture_stack' do
    Given(:stack) { nil }
    Given(:use) { use_fixture_stack(stack) }
    Given(:stack_location) { Roro::CLI.stacks }
    Given(:stacks) { Roro::CLI.stacks }
    Given(:actual_stack) { /lib\/roro\/stacks/}
    Given(:fixture_stack) { /fixtures\/files\/stacks\/alpha/ }

    describe 'when not called' do
      focus
      Then { assert_match actual_stack, stacks }
    end

    describe 'when called without stack arg' do
      Given { use_fixture_stack }
      Then { assert_match actual_stack, stack_location }
    end

    describe 'when called with stack ' do
      Given { use_fixture_stack('alpha') }
      Then { assert_match fixture_stack, stack_location }
    end
  end


  describe '#set_workench(dir)' do
    # Given { set_workbench('echo') }
    # Then { assert_match /echo/, Dir.pwd }
  end

  describe '#use_fixture_stack(stack)' do
    # Given { use_fixture_stack('echo') }
    # Then { assert_match /echo/, Roro::CLI.stacks }
  end

end
