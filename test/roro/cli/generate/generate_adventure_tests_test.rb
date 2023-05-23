# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_choice_tests' do
  Given(:workbench) { 'test_adventure/lib' }
  Given(:generate) { Roro::CLI.new.generate_adventure_tests }

  # Given { quiet { generate } }
  Given { generate }
  describe 'must generate' do
    Given(:directory) do
      [
        'test/roro/stacks/unstoppable_developer_styles/okonomi',
        'languages/ruby/frameworks/rails/databases/postgres',
        'versions/postgres_13_5/versions/ruby_2_7/schedulers/resque',
        'versions/rails_6_1'
      ].join('/')
    end
    describe 'nested directories' do
      Then { assert_directory directory }
    end
    describe 'when case specified must generate a test file with' do
      Given(:file) { "#{directory}/_test.rb" }
      Then { assert_file file }

      describe 'adventure title in first describe block' do
        Then { assert_file file, /describe 'unstoppable_developer_styles:/ }
        And { assert_file file, /unstoppable_developer_styles: okonomi/ }
        #     And { assert_file file, /languages: ruby/ }
        #     And { assert_file file, /frameworks: rails/ }
      end
    end
  end
end
