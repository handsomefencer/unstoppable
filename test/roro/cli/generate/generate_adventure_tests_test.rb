# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:workbench) {}
  Given(:generate) { Roro::CLI.new.generate_adventure_tests }
  Given { use_stub_stack }

  Given { quiet { generate } }

  describe 'must generate' do
    describe 'nested directories' do
      Then { assert_directory 'test/roro/stacks/1/1/1' }
      And { assert_file 'test/roro/stacks/1/3/1/1/1/1/1/1' }
    end
  end

  describe 'when case specified must generate a test file with' do
    Given(:file) { 'test/roro/stacks/1/3/1/1/1/1/1/1/_test.rb' }
    Then { assert_file file }

    describe 'adventure title in first describe block' do
      Then { assert_file file, /describe 'unstoppable_developer_styles:/ }
      And { assert_file file, /unstoppable_developer_styles: okonomi/ }
      And { assert_file file, /languages: ruby/ }
      And { assert_file file, /frameworks: rails/ }
    end
  end
end
