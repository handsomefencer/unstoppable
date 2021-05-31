# frozen_string_literal: true

require 'test_helper'

class DummyClass; include Roro::Crypto::FileReflection; end

describe Roro::Crypto::FileReflection do
  let(:subject)   { DummyClass.new }
  let(:workbench) { 'crypto/roro' }
  let(:directory) { 'roro' }
  let(:pattern)   { '.env' }
  let(:execute)   { subject.source_files directory, pattern }

  describe ':source_files(directory, pattern' do
    context 'when no files match the pattern' do

      Then { assert_equal execute, [] }
    end

    context 'when the pattern is .env.enc' do
      let(:pattern) { '.env.enc' }

      Given { insert_dummy_env_enc }
      Then  { assert_includes execute, 'roro/env/dummy.env.enc' }
    end

    context 'when a file matches the pattern' do

      Given { insert_dummy }
      Then  { assert_includes execute, 'roro/env/dummy.env' }
    end

    context 'when a file is nested two levels deep' do

      Given { insert_dummy 'roro/containers/backend/env/dummy.env' }
      Then  { assert_includes execute, 'roro/containers/backend/env/dummy.env' }
    end

    context 'when nested three levels deep' do

      Given { insert_dummy 'roro/containers/backend/env/dummy.env' }
      Then  { assert_includes execute, 'roro/containers/backend/env/dummy.env' }
    end

    context 'when pattern contains regex' do
      let(:pattern) { 'dummy*.env' }

      Given { insert_dummy 'roro/env/dummy.subenv.env' }
      Then  { assert_includes execute, 'roro/env/dummy.subenv.env' }
    end
  end

  describe ':gather_environments' do
    let(:execute)   { subject.gather_environments directory, extension }
    let(:extension) { '.env' }

    context 'when no file matches extension' do

      Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
    end

    context 'when extension is .env.enc' do
      let(:extension) { '.env.enc' }

      Given { insert_dummy_env_enc }
      Then  { assert_includes execute, 'dummy' }
    end

    context 'when extension is .env' do

      Given { insert_dummy }
      Then  { assert_includes execute, 'dummy' }
    end

    context 'when file is nested deeply' do

      Given { insert_dummy 'roro/containers/backend/env/dummy.env' }
      Then  { assert_includes execute, 'dummy' }
    end

    context 'when file is a subenv' do

      Given { insert_dummy 'roro/env/dummy.subenv.env' }
      Then  { assert_includes execute, 'dummy' }
    end

    context 'when files are mixed and nested' do

      Given { insert_dummy 'roro/containers/backend/dummy.subenv.env' }
      Given { insert_dummy 'roro/env/smart.env' }
      Then  { assert_includes execute, 'dummy' }
      And   { assert_includes execute, 'smart' }
    end

    context 'when files are keys' do
      let(:directory) { 'roro/keys' }
      let(:extension) { '.key' }

      context 'when one key' do

        Given { insert_dummy_key }
        Then  { assert_includes execute, 'dummy' }
      end

      context 'when multiple keys' do

        Given { insert_dummy_key }
        Given { insert_dummy_key 'smart.key' }
        Then  { assert_equal execute.to_set, %w[dummy smart].to_set }
      end
    end
  end

  describe ':get_key' do
    let(:key_file)     { 'roro/keys/dummy.key' }
    let(:var_from_ENV) { 's0m3k3y-fr0m-variable' }
    let(:execute)      { subject.get_key('dummy') }

    describe 'when key is not set' do
      let(:error)         { Roro::Crypto::KeyError }
      let(:error_message) { 'No DUMMY_KEY set' }

      Then { assert_correct_error }
    end

    context 'when key is set in a key file' do

      Given { insert_dummy_key }
      Then  { assert_equal execute, dummy_key }
    end

    context 'when key is set in ENV' do

      Then  { with_env_set { assert_equal execute, var_from_ENV } }
    end

    context 'when key is set in a key file and an environment file' do

      Given { insert_dummy_key }
      Then  { with_env_set { assert_equal execute, var_from_ENV } }
    end
  end
end
