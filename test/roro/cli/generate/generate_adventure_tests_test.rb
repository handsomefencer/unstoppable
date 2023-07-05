# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:workbench) {}
  Given(:generate) { Roro::CLI.new.generate_adventure_tests }
  Given { use_fixture_stack('alpha') }
  Given(:stacks_test_dir) { 'test/roro/stacks' }
  Given { generate }

  Given(:directories) do
    %w[111 32].map { |d| "#{stacks_test_dir}/#{d.chars.join('/')}" }
  end

  Given(:directory) { directories.first }

  describe 'must create correct directories' do
    # Then { assert_equal 'test/roro/stacks/1/1/1', directories[0] }
    # And { assert_equal 'test/roro/stacks/3/2', directories[-1] }
  end

  describe 'must generate shared_tests.rb' do
    Then { assert_file stacks_test_dir }
    Then { assert_file "#{stacks_test_dir}" }
  end

  describe 'must generate _test.rb file in each directory' do
    Given(:file) { "#{directory}/_test.rb" }
    # Then { assert_file file }

    describe 'adventure title in first describe block' do
      #   Then { assert_file file, /describe '3 -> 2: unstoppable/ }
    end
  end
end
