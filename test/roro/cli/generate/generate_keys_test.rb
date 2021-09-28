# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_keys' do
  let(:subject)   { Roro::CLI.new }
  let(:envs)      { [] }
  let(:generate)  { suppress_output { subject.generate_keys(*envs) } }
  let(:workbench) { 'roro' }

  before { stubs_answer('y') }

  context 'when no environments supplied and' do
    context 'when no .smart.env files' do
      When(:error) { Roro::Crypto::EnvironmentError }
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
