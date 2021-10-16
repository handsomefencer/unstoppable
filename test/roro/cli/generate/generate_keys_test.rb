# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_keys' do
  Given(:subject)   { Roro::CLI.new }
  Given(:envs)      { nil }
  Given(:generate)  { quiet { subject.generate_keys(*envs) } }
  Given(:workbench) { 'mise/fresh/roro' }

  before { stubs_answer('y') }

  context 'when no environments supplied and' do
    context 'when no .smart.env files' do
      When(:error) { Roro::Error }
      Then { assert_raises(error) { generate } }
    end

    context 'when one .smart.env file' do
      Given { insert_dummy_env }
      Given { generate }
      Then  { assert_file 'roro/keys/dummy.key' }
    end

    context 'when two different .smart.env files' do
      Given { insert_dummy_env }
      Given { insert_dummy_env './roro/stupid.smart.env' }
      Given { generate }
      Then  { assert_file 'roro/keys/dummy.key' }
      And   { assert_file 'roro/keys/stupid.key' }
    end
  end

  context 'when one environment supplied' do
    When(:envs) { ['dummy'] }
    Given { generate }
    Then  { assert_file('roro/keys/dummy.key') }
  end

  context 'when two environments supplied' do
    When(:envs) { %w[dummy smart] }
    Given { generate }
    Then  { assert_file('roro/keys/dummy.key') }
    And   { assert_file('roro/keys/smart.key') }
  end
end
