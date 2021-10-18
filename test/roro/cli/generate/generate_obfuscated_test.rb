# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_obfuscated' do
  Given(:subject)   { Roro::CLI.new }
  Given(:workbench) { 'exposed/roro' }
  Given(:envs) { [] }
  Given(:generate) { quiet { subject.generate_obfuscated(*envs) } }

  context 'when no environments supplied' do
    Given(:error) { Roro::Error }

    context 'when no dummy.env files and' do
      context 'when no key' do
        Then  { assert_raises(error) { generate } }
      end

      context 'when key' do
        Given { insert_key_file 'smart.key'}
        Then  { assert_raises(error) { generate } }
      end
    end

    context 'when .dummy.env files and' do
      before { insert_dummy }

      context 'when no key' do
        Then  { assert_raises(Roro::Error) { generate } }
      end

      context 'when matching key' do
        Given { insert_dummy_key }
        Given { generate }
        Then  { assert_file 'roro/env/dummy.env.enc' }
      end
    end

    context 'when multiple .env files and keys' do
      Given { insert_dummy }
      Given { insert_dummy_key }
      Given { insert_dummy 'roro/env/smart.env' }
      Given { insert_dummy_key 'smart.key' }
      Given { generate }
      Then  { assert_file 'roro/env/dummy.env.enc' }
      And   { assert_file 'roro/env/smart.env.enc' }
    end
  end
end
