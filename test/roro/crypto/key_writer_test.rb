# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::KeyWriter do
  let(:workbench) { 'crypto/roro' }
  let(:subject)   { Roro::Crypto::KeyWriter.new }

  describe '#write_keyfile(environment)' do
    Given { quiet { subject.write_keyfile 'dummy' } }
    Then  { assert_file 'roro/keys/dummy.key', /=/ }
  end

  describe '#write_keyfiles(environments, directory, extension' do
    let(:execute) { quiet { subject.write_keyfiles envs, './roro', '.env' } }

    context 'when no environments supplied and' do
      let(:envs) { [] }

      context 'when file matches extension' do
        Given { insert_dummy }
        Given { execute }
        Then  { assert_file 'roro/keys/dummy.key' }
      end

      context 'when file nested deeply' do
        Given { insert_dummy 'roro/containers/dummy.smart.env' }
        Given { execute }
        Then  { assert_file 'roro/keys/dummy.key' }
      end

      context 'when file is subenv' do
        Given { insert_dummy 'roro/dummy.subenv.smart.env' }
        Given { execute }
        Then  { assert_file 'roro/keys/dummy.key' }
      end

      context 'when file is nested subenv' do
        Given { insert_dummy 'roro/containers/dummy.subenv.smart.env' }
        Given { execute }
        Then  { assert_file 'roro/keys/dummy.key' }
      end

      context 'when multiple files' do
        Given { insert_dummy }
        Given { insert_dummy('roro/containers/stupid.stupidenv.smart.env') }
        Given { execute }
        Then  { assert_file 'roro/keys/stupid.key' }
        And   { assert_file 'roro/keys/dummy.key' }
      end

      context 'when no files matching' do
        When(:error)     { Roro::Crypto::EnvironmentError }
        When(:error_msg) { 'No .env files in ./roro' }
        Then { assert_correct_error }
      end
    end

    context 'when one environment supplied' do
      When(:envs) { ['dummy'] }
      Given { execute }
      Then  { assert_file 'roro/keys/dummy.key' }
    end

    context 'when multiple environments supplied' do
      context 'when no files match the pattern' do
        When(:envs) { %w[dummy smart stupid] }
        Given { execute }
        Then  { assert_file 'roro/keys/dummy.key' }
        And   { assert_file 'roro/keys/smart.key' }
        And   { assert_file 'roro/keys/stupid.key' }
      end
    end
  end
end
