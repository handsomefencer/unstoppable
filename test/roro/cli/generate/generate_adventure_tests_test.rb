# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:workbench) {}
  Given(:generate) { Roro::CLI.new.generate_adventure_tests }
  Given { use_fixture_stack('alpha') }
  Given { generate }
  Given(:base) { 'test/roro/stacks' }

  Given(:directories) do
    %w[111 112 32].map { |d| "#{stacks_test_dir}/#{d.chars.join('/')}" }
  end

  Given(:directory) { directories.first }
  Given(:stacks_test_dir) { 'test/roro/stacks' }
  Given(:shared_tests_file) { "#{dir}/shared_tests.rb" }
  Given(:case_test_file) { "#{dir}/_test.rb" }
  Given(:dir) { 'test/roro/stacks/okonomi/php/laravel' }

  describe 'when directory is ancestor base must have shared_tests.rb' do
    Given(:dir) { 'test/roro/stacks' }

    describe 'must require test helper' do
      Then { assert_file(shared_tests_file, /require 'test_helper'/) }
    end

    describe 'must have stacked method' do
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

  describe 'when directory is not ancestor' do
    describe 'will not contain shared_tests.rb' do
      Then { refute_file(shared_tests_file) }
    end

    describe 'must contain _tests.rb' do
      Then { assert_file(case_test_file) }
    end

    describe 'must contain dummy directory' do
      Then { assert_file("#{dir}/dummy/.keep") }
    end
  end

  describe '_test.rb' do
    Given(:f) { case_test_file }

    describe 'must require shared tests' do
      Then { assert_file(f, %r{relative '../shared_tests'}) }
    end

    describe 'must describe whata the case' do
      Then { assert_file(f, /describe '1 okonomi -> 1 php -> 1 laravel'/) }
    end
  end
end
