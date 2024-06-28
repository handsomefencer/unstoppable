# frozen_string_literal: true

require 'stack_test_helper'

describe 'Roro::CLI#generate_adventure_tests' do
  Given(:workbench) {}
  Given(:case_test_file) { "#{dir}/_test.rb" }
  Given { use_fixture_stack('echo') }
  Given do
      Roro::CLI.new.generate_adventure_tests
    #  quiet { Roro::CLI.new.generate_adventure_tests }
  end

  describe 'when directory is ancestor base' do
    Given(:dir) { 'test/roro/stacks' }
    focus
    Then do
      assert_content('test/roro/stacks/_manifest.yml', /stacks/)
      assert_content('test/roro/stacks/_manifest_auth_approaches.yml', /stacks/)
      assert_file 'test/roro/stacks/sqlite/bun/omakase'
      assert_file 'test/roro/stacks/sqlite/bun/omakase/_test.rb'
    end
  end
end
