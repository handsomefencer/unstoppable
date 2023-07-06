# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:workbench) {}
  Given(:case_test_file) { "#{dir}/_test.rb" }
  Given(:dir) { 'test/roro/stacks/okonomi/php/laravel' }
  Given(:shared_tests_file) { "#{dir}/shared_tests.rb" }

  Given { use_fixture_stack('alpha') }
  Given { quiet { Roro::CLI.new.generate_adventure_tests } }

  describe 'when directory is ancestor base' do
    Given(:dir) { 'test/roro/stacks' }

    describe 'must require test helper shared_tests.rb' do
      Then { assert_file(shared_tests_file, /require 'test_helper'/) }
    end

    describe 'must have stacked method in shared_tests.rb' do
      Then { assert_file(shared_tests_file, /def assert_stacked_stack/) }
    end
  end

  describe 'when directory is ancestor' do
    Given(:dir) { 'test/roro/stacks/okonomi' }

    describe 'must require shared tests' do
      Then { assert_file(shared_tests_file, %r{relative '../shared_tests'}) }
    end

    describe 'must not have a _test.rb file' do
      Then { refute_file(case_test_file) }
    end
  end

  describe 'when directory is last descendent' do
    describe 'will not contain shared_tests.rb' do
      Then { refute_file(shared_tests_file) }
    end

    describe 'must contain dummy directory' do
      Then { assert_file("#{dir}/dummy/.keep") }
    end

    describe 'must contain _tests.rb' do
      Given(:f) { case_test_file }

      describe 'must require shared tests' do
        Then { assert_file(f, %r{relative '../shared_tests'}) }
      end

      describe 'must describe whata the case' do
        Then { assert_file(f, /describe '1 okonomi -> 1 php -> 1 laravel'/) }
      end
    end
  end
end
