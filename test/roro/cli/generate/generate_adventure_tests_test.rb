# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_adventure_tests' do
  Given(:workbench) {}
  Given(:case_test_file) { "#{dir}/_test.rb" }
  Given { use_fixture_stack('echo') }
  Given {  Roro::CLI.new.generate_adventure_tests }

  describe 'when directory is ancestor base' do
    Given(:dir) { 'test/roro/stacks' }
    Then { assert_file 'test/roro/stacks/sqlite/bun/omakase' }
  end
end
