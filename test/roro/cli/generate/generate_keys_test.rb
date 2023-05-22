# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_keys' do
  Given(:workbench) { 'mise/fresh/roro' }
  Given(:envs)      { nil }
  Given(:generate)  { Roro::CLI.new.generate_keys(*envs) }

  before { stubs_answer('y') }

  context 'when no environments supplied and' do
    context 'when no .smart.env files' do
      When(:error) { Roro::Error }
      Then { assert_raises(error) { quiet { generate } } }
    end

    context 'when one .smart.env file' do
      Given { insert_dummy_env }
      Given { quiet { generate } }
      Then  { assert_file 'roro/keys/dummy.key' }
    end

    context 'when two different .smart.env files' do
      Given { insert_dummy_env }
      Given { insert_dummy_env './roro/stupid.smart.env' }
      Given { quiet { generate } }
      Then  { assert_file 'roro/keys/dummy.key' }
      And   { assert_file 'roro/keys/stupid.key' }
    end
  end

  context 'when one environment supplied' do
    When(:envs) { ['dummy'] }
    Given { quiet { generate } }
    Then  { assert_file('roro/keys/dummy.key') }
  end

  context 'when two environments supplied' do
    When(:envs) { %w[dummy smart] }
    Given { quiet { generate } }
    Then  { assert_file('roro/keys/dummy.key') }
    And   { assert_file('roro/keys/smart.key') }
  end
end
