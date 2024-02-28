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
  end
end
