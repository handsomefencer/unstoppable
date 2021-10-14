# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_mise' do
  Given { skip }
  let(:cli)       { Roro::CLI.new }
  let(:mise)      { 'mise' }
  let(:workbench) { 'workbench' }

  Given { quiet { cli.generate_mise(mise) } }

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
    Then  { assert_directory 'mise/mise.roro' }
  end

  describe 'must generate containers' do
    Then  { assert_directory 'mise/containers/backend/scripts' }
    And   { assert_directory 'mise/containers/frontend/scripts' }
    And   { assert_directory 'mise/containers/database/env' }
  end

  describe 'must generate env' do
    Then  { assert_directory 'mise/env/base.env' }
    And   { assert_file 'mise/containers/backend/env/base.env' }
  end

  describe 'must generate keys' do
    Then  { assert_file 'mise/keys/base.key' }
  end
end
