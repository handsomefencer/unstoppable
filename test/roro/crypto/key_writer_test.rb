# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::KeyWriter do
  Given(:workbench) { 'mise/fresh/roro' }
  Given(:subject)   { Roro::Crypto::KeyWriter.new }

  describe '#write_keyfile(environment)' do
    Given { quiet { subject.write_keyfile *args } }

    context 'when extension is impicit' do
      When(:args) { ['dummy']}
      Then { assert_file 'roro/keys/dummy.key', /=/ }
    end

    context 'when extension is explicit' do
      When(:args) { %w[dummy .key] }
      Then { assert_file 'roro/keys/dummy.key', /=/ }
    end

    context 'when extension is .passkey' do
      When(:args) { %w[dummy .passkey] }
      Then { assert_file 'roro/keys/dummy.passkey', /=/ }
    end
  end

  describe '#write_keyfiles(environments, directory, extension' do
    Given(:write_keyfiles) { quiet { subject.write_keyfiles *args } }

    context 'when no environments' do
      Given(:args) { %w[]}

      context 'when no directory' do
        context 'when no extension' do
          context 'when no encryptable must return error' do
            Given(:workbench) { 'mise/fresh/roro'}
            Given(:error)     { Roro::Error }
            Given(:error_msg) { 'No .env files in' }
            Given(:execute)   { quiet { subject.write_keyfiles } }
            Then { assert_correct_error }
          end

          context 'when encryptable must generate keys' do
            Given(:workbench) { 'mise/exposed/roro'}
            Given(:args)      { %w[]}
            Given { write_keyfiles }
            Then { assert_file 'roro/keys/ci.key'  }
            And  { assert_file 'roro/keys/base.key'  }
            And  { assert_file 'roro/keys/dummy.key'  }
          end
        end

        context 'when specified extension' do
          context 'when encryptable must not generate any keys' do
            Given(:workbench) { 'mise/exposed/roro'}
            Given(:args)      { [[], nil, '.passkey'] }
            Given { write_keyfiles }
            Then { assert_file 'roro/keys/ci.passkey' }
          end
        end
      end

      context 'when directory' do
        Given(:workbench) { 'mise/exposed/mise'}
        Given(:args)      { [[], 'mise'] }
        Given { write_keyfiles }
        Then { assert_file 'mise/keys/dummy.key' }
      end

      context 'when file nested deeply and is subenv' do
        Given { insert_dummy 'roro/containers/backend/env/nested.subenv.env' }
        Given { write_keyfiles }
        Then  { assert_file 'roro/keys/nested.key' }
      end
    end

    context 'when one environment supplied' do
      Given(:args) { [['dummy']]}
      Given { write_keyfiles }
      Then  { assert_file 'roro/keys/dummy.key' }
    end

    context 'when multiple environments supplied' do
      context 'when no files match the pattern' do
        Given(:args) { [['dummy']]}
        Given(:args) { [%w[dummy smart stupid]]}
        Given { write_keyfiles }
        Then  { assert_file 'roro/keys/dummy.key' }
        And   { assert_file 'roro/keys/smart.key' }
        And   { assert_file 'roro/keys/stupid.key' }
      end
    end
  end
end
