# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_obfuscated' do
  before do
    prepare_destination 'crypto/roro'
    Thor::Shell::Basic.any_instance.stubs(:ask).returns('y')
  end

  Given(:cli) { Roro::CLI.new }

  context 'when no environments supplied' do
    Given(:generate) { cli.generate_obfuscated }

    context 'when no .smart.env files and' do
      context 'when no key' do
        Then  { assert_raises(Roro::Crypto::EnvironmentError) { generate } }
      end

      context 'when key' do
        Given { insert_key_file }

        Then  { assert_raises(Roro::Crypto::EnvironmentError) { generate } }
      end
    end

    context 'when .smart.env files and' do
      Given { insert_dummy }

      context 'when no key' do
        Then  { assert_raises(Roro::Crypto::KeyError) { generate } }
      end

      context 'when matching key' do
        Given { insert_key_file }
        Given { generate }

        Then  { assert_file './roro/dummy.smart.env.enc' }
      end
    end

    context 'when multiple .smart.env files and keys' do
      Given { insert_dummy }
      Given { insert_key_file }
      Given { insert_dummy('./roro/stupid.smart.env') }
      Given { insert_key_file('stupid.key') }
      Given { generate }

      Then  { assert_file './roro/dummy.smart.env.enc' }
      And   { assert_file './roro/stupid.smart.env.enc' }
    end
  end
end
