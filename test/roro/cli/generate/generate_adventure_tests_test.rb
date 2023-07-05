# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:workbench) {}
  Given(:generate) { Roro::CLI.new.generate_adventure_tests }
  Given { use_fixture_stack('alpha') }
  Given(:stacks_test_dir) { 'test/roro/stacks' }
  Given { generate }

  Given(:directories) do
    %w[111 112 32].map { |d| "#{stacks_test_dir}/#{d.chars.join('/')}" }
  end

  Given(:directory) { directories.first }

  describe 'when directory is base ancestor' do
    Given(:base) { 'test/roro/stacks' }
    Given(:file) { "#{base}/shared_tests.rb" }

    Then { assert_file(base) }

    describe 'must not have _test file' do 
      Then { refute_file("#{base}/_test.rb") }
    end

    describe 'must require test helper' do
      Then { assert_file(file, /require 'test_helper'/) }
    end

    describe 'must have assert_stacked_stack method' do
      Then { assert_file(file, /def assert_stacked_stack/) }
    end
  end

  describe 'when directory is ancestor' do
    Given(:file) { 'test/roro/stacks/okonomi/shared_tests.rb' }
    Then do
      assert_file(file, %r{require_relative '../shared_tests'})
      assert_file(file, /def assert_stacked_okonomi/)
    end
  end

  describe 'must when directory has no children' do
    Given(:file) { 'test/roro/stacks/okonomi/php/laravel/_test.rb' }
    Then { assert_file(file, %r{require_relative '../shared_tests'}) }
  end

  describe 'must generate shared tests in ancestor directories' do
    Then do
      assert_file('test/roro/stacks/shared_tests.rb')
      assert_file('test/roro/stacks/okonomi/shared_tests.rb')
      assert_file('test/roro/stacks/okonomi/php/shared_tests.rb')
    end
  end

  describe 'will not generate shared tests unless in ancestor directory' do
    Then do
      refute_file('test/roro/stacks/okonomi/php/laravel/shared_tests.rb')
    end
  end

  describe 'shared_tests.rb' do
    Given(:file) { 'test/roro/stacks/shared_tests.rb' }

    describe 'when at top level of stack' do
      Then { assert_file(file, /require 'test_helper'/) }
    end

    describe 'when not top level of stack' do
      Given(:file) { 'test/roro/stacks/okonomi/shared_tests.rb' }
      Then { assert_file(file, %r{require_relative '../shared_tests'}) }
    end
  end

  describe 'must create correct directories' do
    # And { assert_equal 'test/roro/stacks/3/2', directories[-1] }
  end

  describe 'must generate shared_tests.rb' do
    # Then { assert_file "#{stacks_test_dir}/1/shared_test.rb" }
    # And { assert_file "#{stacks_test_dir}/1/1/shared_test.rb" }
    # And { assert_file "#{stacks_test_dir}/1/1/1/shared_test.rb" }
  end

  describe 'must generate _test.rb file in each directory' do
    # Given(:file) { "#{directory}/_test.rb" }
    # Then { assert_file file }

    describe 'adventure title in first describe block' do
      #   Then { assert_file file, /describe '3 -> 2: unstoppable/ }
    end
  end
end
