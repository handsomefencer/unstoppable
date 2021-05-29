# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::Obfuscator do
  let(:subject)      { Roro::Crypto::Obfuscator.new }
  let(:workbench)    { 'crypto/roro' }
  let(:directory)    { 'roro' }
  let(:extension)    { '.env' }
  let(:environments) { ['dummy'] }

  describe '#obfuscate_file(file, key)' do
    let(:key) { dummy_key }

    Given { insert_dummy_encryptable }
    Given { subject.obfuscate_file 'roro/dummy.env', key }
    Then  { assert_file 'roro/dummy.env.enc' }
  end

  describe '#obfuscate(envs, dir, ext)' do
    let(:execute) { subject.obfuscate environments, directory, extension }

    describe 'when environments empty' do
      let(:environments) { [] }

      Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
    end

    context 'when obfuscatable but no matching key' do
      Given { insert_dummy_encryptable }
      Then  { assert_raises(Roro::Crypto::KeyError) { execute } }
    end

    context 'when matching key and when' do
      Given { insert_dummy_key }

      context 'obfuscatable' do
        Given { insert_dummy }
        Given { execute }
        Then  { assert_file 'roro/dummy.env.enc' }
      end

      context 'when obfuscatable is subenv' do
        Given { insert_dummy 'roro/dummy.subenv.env' }
        Given { execute }
        Then  { assert_file 'roro/dummy.subenv.env.enc' }
      end

      context 'when obfuscatable is nested deeply' do
        Given { insert_dummy 'roro/containers/app/dummy.subenv.env' }
        Given { execute }
        Then  { assert_file 'roro/containers/app/dummy.subenv.env.enc' }
      end
    end
  end
end
