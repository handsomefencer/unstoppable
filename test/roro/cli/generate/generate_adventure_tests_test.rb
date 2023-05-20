# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:subject) { Roro::CLI.new }
  Given(:workbench) { 'test_adventure/lib' }
  Given(:base)      { 'test/roro/stacks' }
  Given(:generate) { subject.generate_adventure_tests }

  Given { generate }

  describe 'must generate' do
    describe 'nested directories' do
      Then { assert_directory 'test/roro/stacks/1/1/1' }
      And { assert_file 'test/roro/stacks/1/3/1/1/1/1/1/1' }
    end
  end

  describe 'must generate a test file with' do
    Given(:file) { 'test/roro/stacks/1/3/1/1/1/1/1/1/_test.rb' }
    Then { assert_file file }

    describe 'adventure title in first describe block' do
      Then { assert_file file, /describe 'unstoppable_developer_styles:/ }
    end

    describe 'Given block' do
      Then { assert_file file, /Given do/ }
    end
  end
end
