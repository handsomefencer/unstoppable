# frozen_string_literal: true

require 'stack_test_helper'

describe 'Roro::FileReflection' do
  Given(:workbench)    { 'obfuscated/roro' }
  Given(:directory)    { 'roro' }
  Given(:pattern)      { '.env.enc' }
  Given(:environments) { gather_environments directory, extension }

  describe ':source_files(directory, pattern)' do
    Given(:execute) { source_files directory, pattern }

    context 'when directory contains obfuscated files' do
      Then { assert_includes execute, 'roro/env/base.env.enc' }
      And  { assert_includes execute, 'roro/containers/backend/env/ci.env.enc' }
    end

    context 'when pattern is regex' do
      When(:pattern) { 'base*.env.enc' }
      Then { assert_includes execute, 'roro/env/base.env.enc' }
    end

    context 'when directory is empty' do
      When(:workbench) { nil }
      Then { assert_equal execute, [] }
    end
  end

  describe ':gather_environments(dir ext)' do
    Given(:execute) { gather_environments directory, pattern }

    context 'when from obfuscated .env.enc files' do
      Then { assert_includes execute, 'base' }
      And  { assert_includes execute, 'ci' }
    end

    context 'when from exposed .env files' do
      Given(:workbench) { 'exposed/roro' }
      Given(:pattern)   { '.env' }

      Given { insert_dummy('roro/env/dummy.env') }
      Given { insert_dummy('roro/env/base.env') }
      Given { insert_dummy('roro/containers/backend/env/ci.env') }
      Then  { assert_includes execute, 'base' }
      And   { assert_includes execute, 'ci' }

      context 'when .env file is a subenv' do
        Then { assert_includes execute, 'dummy' }
      end
    end

    context 'when from .key files' do
      Given(:directory) { 'roro/keys' }
      Given(:pattern)   { '.key' }

      context 'when one key' do
        Given { insert_dummy_key }
        Then { assert_includes execute, 'dummy' }
      end

      context 'when multiple keys' do
        Given { insert_dummy_key }
        Given { insert_dummy_key 'base.key' }
        Then  { assert_equal %w[dummy base] & execute, %w[dummy base] }
      end
    end

    context 'when no file matches' do
      When(:workbench) { nil }
      Then { assert_raises(Roro::Error) { execute } }
    end
  end

  describe ':get_key' do
    Given(:key_file)     { 'roro/keys/dummy.key' }
    Given(:var_from_ENV) { 's0m3k3y-fr0m-variable' }
    Given(:error)        { Roro::Error }
    Given(:error_msg)    { 'No DUMMY_KEY set' }
    Given(:execute)      { get_key('dummy') }

    context 'when key is' do
      context 'set in key file and' do
        context 'not set in ENV returns key from file' do
          Given { insert_dummy_key }
          Then  { assert_equal execute, dummy_key }
          And   { refute_equal execute, var_from_ENV }
        end

        context 'set in ENV returns key from ENV' do
          Then do
            with_env_set do
              assert_equal execute, var_from_ENV
              refute_equal execute, dummy_key
            end
          end
        end
      end

      context 'not set in key file and' do
        Given(:workbench) { 'exposed/roro' }

        context 'not set in ENV must raise error' do
          Then { assert_correct_error }
        end

        context 'set in ENV must return key from ENV' do
          Then do
            with_env_set do
              assert_equal execute, var_from_ENV
              refute_equal execute, dummy_key
            end
          end
        end
      end
    end
  end
end
