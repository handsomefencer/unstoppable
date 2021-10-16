# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::Obfuscator do
  Given(:subject)   { Roro::Crypto::Obfuscator.new }
  Given(:workbench) { 'mise/exposed/roro' }
  Given(:execute) { quiet { subject.obfuscate *args } }

  describe '#obfuscate(environments, directory, extension)' do
    Given(:args) { nil }

    describe 'errors' do
      Given(:workbench) { 'mise/fresh/roro' }
      Given(:error) { Roro::Error }

      context 'when no args supplied' do
        Given(:error_msg) { 'No .env files in roro' }
        Then { assert_correct_error }
      end

      context 'when obfuscatable but no matching key' do
        Given(:error_msg) { 'No DUMMY_KEY set' }
        Given { insert_dummy_env }
        Then  { assert_correct_error }
      end
    end

    describe 'success' do
      context 'when matching key and' do
        Given { insert_dummy_key 'base.key' }
        Given { insert_dummy_key 'ci.key' }
        Given { insert_dummy_key 'dummy.key' }

        context 'when obfuscatable file' do
          Given { execute }
          Then  { assert_file 'roro/env/base.env.enc' }
          And   { assert_file 'roro/env/ci.env.enc' }
          And   { assert_file 'roro/env/dummy.env.enc' }
        end

        context 'when obfuscatable subenv file' do
          Given { insert_dummy 'roro/env/dummy.subenv.env'}
          Given { execute }
          Then  { assert_file 'roro/env/dummy.subenv.env.enc' }
        end

        context 'when obfuscatable subenv file nested deeply' do
          Given { insert_dummy 'roro/containers/backend/env/dummy.subenv.env' }
          Given { execute }
          Then  { assert_file 'roro/containers/backend/env/dummy.subenv.env.enc' }
        end
      end
    end
  end
end
