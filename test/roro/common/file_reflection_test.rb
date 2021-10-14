# frozen_string_literal: true

require 'test_helper'

describe Roro::FileReflection do
  let(:workbench)    { 'obfuscated/roro' }
  let(:directory)    { 'roro' }
  let(:pattern)      { '.env.enc' }
  let(:environments) { gather_environments directory, extension }

  describe ':source_files(directory, pattern)' do
    let(:execute)    { source_files directory, pattern }

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
    let(:execute) { gather_environments directory, pattern }

    context 'when from obfuscated .env.enc files' do
      Then { assert_includes execute, 'base' }
      And  { assert_includes execute, 'ci' }
    end

    context 'when from exposed .env files' do
      let(:workbench) { 'exposed/roro' }
      let(:pattern)   { '.env' }
      Then { assert_includes execute, 'base' }
      And  { assert_includes execute, 'ci' }

      context 'when .env file is a subenv' do
        Then { assert_includes execute, 'dummy' }
      end
    end

    context 'when from .key files' do
      let(:directory) { 'roro/keys' }
      let(:pattern)   { '.key' }

      context 'when one key' do
        Then { assert_includes execute, 'dummy' }
      end

      context 'when multiple keys' do
        Then { assert_equal %w[dummy base] & execute, %w[dummy base] }
      end
    end

    context 'when no file matches' do
      When(:workbench) { nil }
      Then { assert_raises(Roro::Error) { execute } }
    end
  end

  describe ':get_key' do
    let(:key_file)     { 'roro/keys/dummy.key' }
    let(:var_from_ENV) { 's0m3k3y-fr0m-variable' }
    let(:error)        { Roro::Error }
    let(:error_msg)    { 'No DUMMY_KEY set' }
    let(:execute)      { get_key('dummy') }

    context 'when key is' do
      context 'set in key file and' do
        context 'not set in ENV returns key from file' do
          Then { assert_equal execute, dummy_key }
          And  { refute_equal execute, var_from_ENV }
        end

        context 'set in ENV returns key from ENV' do
          Then { with_env_set {
            assert_equal execute, var_from_ENV
            refute_equal execute, dummy_key
          } }
        end
      end

      context 'not set in key file and' do
        let(:workbench) { 'exposed/roro' }

        context 'not set in ENV must raise error' do
          Then { assert_correct_error }
        end

        context 'set in ENV must return key from ENV' do
          Then { with_env_set {
            assert_equal execute, var_from_ENV
            refute_equal execute, dummy_key
          } }
        end
      end
    end
  end
end
