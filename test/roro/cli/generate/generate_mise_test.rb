# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_mise' do
  Given(:workbench) { 'empty' }
  Given(:mise)      { 'mise' }
  Given(:generate) {  Roro::CLI.new.generate_mise(mise) }
  Given { quiet { generate } }

  describe 'Roro::CLI.mise' do
    context 'when mise directory' do
      context 'is roro' do
        When(:mise) { 'roro' }
        Then { assert_match 'workbench/roro', Roro::CLI.mise_location }
        And  { assert_equal 'roro', Roro::CLI.mise }
      end

      context 'is mise' do
        When(:mise) { 'mise' }
        Then { assert_match 'workbench/mise', Roro::CLI.mise_location }
        And  { assert_equal 'mise', Roro::CLI.mise }
      end

      context 'is alternative named like bench' do
        When(:mise) { 'bench' }
        Then { assert_match 'workbench/bench', Roro::CLI.mise_location }
        And  { assert_equal 'bench', Roro::CLI.mise }
      end
    end
  end

  describe 'must generate mise/mise.roro file' do
    Then { assert_directory 'mise/mise.roro' }
  end
end
