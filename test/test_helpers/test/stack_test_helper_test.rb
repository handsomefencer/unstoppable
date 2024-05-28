# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::TestHelpers::StackTestHelper do
  describe '#prepare_destination' do
    Given(:files) { Dir.glob("#{Dir.pwd}/**/*") }

    describe "when workbench is not called" do
      Then { assert_equal ENV['PWD'], Dir.pwd }
      And { refute_empty files }
    end

    describe 'when workbench is called but unspecified' do
      Given(:workbench) { }
      Then do
        refute_equal ENV['PWD'], Dir.pwd
        assert_match /tmp/, Dir.pwd
        assert_empty files
      end
    end

    describe 'when workbench is called and specified' do
      Given(:workbench) { 'crypto' }
      Then do
        refute_equal ENV['PWD'], Dir.pwd
        assert_match /tmp/, Dir.pwd
        refute_empty files
      end
    end
  end

  describe '#use_fixture_stack' do
    Given(:stacks) { Roro::CLI.stacks }
    Given(:actual_stack) { /lib\/roro\/stacks/}
    Given(:fixture_stack) { /fixtures\/files\/stacks\/alpha/ }

    describe 'when not called must use active stack' do
      Then { assert_match actual_stack, stacks }
    end

    describe 'when called without stack must use active stack' do
      Given { use_fixture_stack }
      Then { assert_match actual_stack, stacks }
    end

    describe 'when called with fixture stack must use fixture stack' do
      Given { use_fixture_stack('alpha') }
      Then { assert_match fixture_stack, stacks }
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
end
