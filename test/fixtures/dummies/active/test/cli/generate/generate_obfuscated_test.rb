# frozen_string_literal: true

require 'stack_test_helper'

describe 'Roro::CLI#generate_obfuscated' do
  Given(:workbench) { 'exposed/roro' }
  Given(:envs) { [] }
  Given(:generate) { Roro::CLI.new.generate_obfuscated(*envs) }

  context 'when no environments supplied' do
    Given(:error) { Roro::Error }

    context 'when no dummy.env files and' do
      context 'when no key' do
        Then  { assert_raises(error) { quiet { generate } } }
      end

      context 'when key' do
        Given { insert_key_file 'smart.key' }
        Then  { assert_raises(error) { quiet { generate } } }
      end
    end

    context 'when .dummy.env files and' do
      before { insert_dummy }

      context 'when no key' do
        Then  { assert_raises(Roro::Error) { quiet { generate } } }
      end

      context 'when matching key' do
        Given { insert_dummy_key }
        Given { quiet { generate } }
        Then  { assert_file 'roro/env/dummy.env.enc' }
      end
    end

    context 'when multiple .env files and keys' do
      Given { insert_dummy }
      Given { insert_dummy_key }
      Given { insert_dummy 'roro/env/smart.env' }
      Given { insert_dummy_key 'smart.key' }
      Given { quiet { generate } }
      Then  { assert_file 'roro/env/dummy.env.enc' }
      And   { assert_file 'roro/env/smart.env.enc' }
    end
  end
end
