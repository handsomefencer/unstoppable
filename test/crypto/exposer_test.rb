require 'test_helper'

describe Roro::Crypto::Exposer do
  let(:workbench)    { 'crypto/roro' }
  let(:directory)    { './roro' }
  let(:filename)     { 'dummy' }
  let(:environments) { [environment] }
  let(:environment)  { 'dummy' }
  let(:subject)      { Roro::Crypto::Exposer.new }

  describe '#expose_file(file, key)' do
    let(:key) { dummy_key }

    Given { insert_dummy_env_enc }
    Given { subject.expose_file('roro/env/dummy.env.enc', key) }
    Then  { assert_file './roro/env/dummy.env', /DATABASE_HOST/ }
  end

  describe '#expose(envs, dir, ext)' do
    let(:execute) { subject.expose environments, directory, '.env.enc' }

    context 'when no environments supplied and' do
      let(:environments) { [] }

      context 'when no exposeable files and no key' do
        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute} }
      end

      context 'when exposeable files and no key' do
        Given { insert_dummy_decryptable }
        Then  { assert_raises(Roro::Crypto::KeyError) { execute} }
      end

      context 'when exposeable files and matching key' do
        Given { insert_dummy_decryptable }
        Given { insert_dummy_key }
        Given { execute }
        Then  { assert_file './roro/dummy.env' }
        And   { assert_file './roro/dummy.env.enc' }
      end

      context 'when exposeable is a subenv' do
        Given { insert_dummy_key }
        Given { insert_dummy_decryptable './roro/dummy.subenv.env.enc' }
        Given { execute }
        Then  { assert_file './roro/dummy.subenv.env' }
      end

      context 'when exposeable is deeply nested' do
        Given { insert_dummy_key }
        Given { insert_dummy_env_enc './roro/containers/dummy.subenv.env.enc' }
        Given { execute }
        Then  { assert_file './roro/containers/dummy.subenv.env' }
        Then  { assert_file './roro/containers/dummy.subenv.env.enc' }
      end
    end

    context 'when one environment supplied' do
      context 'when no matching key or decryptable files' do
        let(:environments) { ['dummy']}

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end

      context 'when no matching key but matching decryptable files' do
        Given { insert_dummy_decryptable }
        Then  { assert_raises(Roro::Crypto::KeyError) { execute } }
      end

      context 'when matching key and decryptable files' do
        Given { insert_dummy_key }
        Given { insert_dummy_decryptable }
        Given { insert_dummy_decryptable('./roro/smart.env.enc') }

        describe 'must decrypt file' do
          Given { execute }
          Then  { assert_file './roro/dummy.env' }
          And   { assert_file './roro/dummy.env.enc' }
        end

        describe 'must not decrypt any other file' do
          Given { execute }
          Then  { refute_file './roro/smart.env' }
          And   { assert_file './roro/smart.env.enc' }
        end
      end
    end
  end
end