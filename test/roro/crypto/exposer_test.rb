# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::Exposer do
  let(:subject)      { Roro::Crypto::Exposer.new }
  let(:workbench)    { 'crypto/roro' }
  let(:directory)    { './roro' }
  let(:environment)  { 'dummy' }
  let(:environments) { [environment] }

  describe '#expose_file(file, key)' do
    let(:key) { dummy_key }

    Given { insert_dummy_env_enc }
    Given { subject.expose_file('roro/smart.env/dummy.smart.env.enc', key) }
    Then  { assert_file 'roro/smart.env/dummy.smart.env', /DATABASE_HOST/ }
  end

  describe '#expose(envs, dir, ext)' do
    let(:execute) { subject.expose environments, directory, '.smart.env.enc' }

    context 'when no environments supplied and' do
      let(:environments) { [] }

      context 'when no exposeable files and no key' do

        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
      end

      context 'when exposeable files and no key' do

        Given { insert_dummy_env_enc }
        Then  { assert_raises(Roro::Crypto::KeyError) { execute } }
      end

      context 'when a key and when matching exposeable' do

        Given { insert_dummy_key }

        context 'exists' do

          Given { insert_dummy_env_enc }
          Given { execute }
          Then  { assert_file 'roro/smart.env/dummy.smart.env' }
          And   { assert_file 'roro/smart.env/dummy.smart.env.enc' }
        end

        context 'is a subenv' do

          Given { insert_dummy_key }
          Given { insert_dummy_env_enc 'roro/dummy.subenv.smart.env.enc' }
          Given { execute }
          Then  { assert_file 'roro/dummy.subenv.smart.env' }
        end

        context 'os deeply nested' do

          Given { insert_dummy_env_enc 'roro/containers/dummy.subenv.smart.env.enc' }
          Given { execute }
          Then  { assert_file 'roro/containers/dummy.subenv.smart.env' }
          Then  { assert_file 'roro/containers/dummy.subenv.smart.env.enc' }
        end
      end
    end

    context 'when one environment supplied' do
      context 'when no matching key or decryptable files' do
        let(:environments) { ['dummy'] }

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end

      context 'when no matching key but matching decryptable files' do

        Given { insert_dummy_env_enc }
        Then  { assert_raises(Roro::Crypto::KeyError) { execute } }
      end

      context 'when matching key and decryptable files' do

        Given { insert_dummy_key }
        Given { insert_dummy_env_enc }
        Given { insert_dummy_env_enc 'roro/smart.env/smart.smart.env.enc' }

        describe 'must decrypt file' do

          Given { execute }
          Then  { assert_file 'roro/smart.env/dummy.smart.env' }
          And   { assert_file 'roro/smart.env/dummy.smart.env.enc' }
        end

        describe 'must not decrypt any other file' do

          Given { execute }
          Then  { refute_file 'roro/smart.env/smart.smart.env' }
          And   { assert_file 'roro/smart.env/smart.smart.env.enc' }
        end
      end
    end
  end
end
