# frozen_string_literal: true

require 'test_helper'

describe 'Roro::TestHelpers::ConfiguratorHelper' do
  Given { skip }

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

  describe '#debuggerer' do
    describe 'when not called' do
      Then do
        refute @rollon_dummies
        refute @rollon_loud
      end
    end

    describe 'when called' do
      Given { debuggerer }
      Then do
        assert @rollon_dummies
        assert @rollon_loud
      end
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

  describe '#debuggerer' do
    # Given { debuggerer }
    # Then { assert @rollon_dummies }
  end
end
