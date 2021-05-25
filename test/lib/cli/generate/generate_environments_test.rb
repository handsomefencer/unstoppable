# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI #generate_obfuscated' do
  before(:all) do
    prepare_destination('roro')
    Thor::Shell::Basic.any_instance.stubs(:ask).returns('y')
  end

  Given(:cli) { Roro::CLI.new }

  Given(:generate) { cli.generate_environments }

  context 'when no arguments supplied' do

    Then { assert_directory './database' }
    And  { assert_directory './nginx' }
    And  { assert_directory './pistil' }
    And  { assert_directory './roro' }
    And  { assert_directory './stamen' }

    context 'when no breadcrumbs' do
      Given { generate }

      Then { assert_file './roro/keys/development.key' }
    end

    context 'when no .env files and' do
      context 'when no key' do
        # Then  { assert_raises(Roro::Crypto::EnvironmentError) { generate } }
      end

      context 'when key' do
        Given { insert_key_file }

        # Then  { assert_raises(Roro::Crypto::EnvironmentError) { generate } }
      end
    end

    context 'when .env files and' do
      Given { insert_dummy }

      context 'when no key' do
        # Then  { assert_raises(Roro::Crypto::KeyError) { generate } }
      end

      context 'when matching key' do
        Given { insert_key_file }
        Given { generate }

        # Then  { assert_file './roro/dummy.env.enc' }
      end
    end

    context 'when multiple .env files and keys' do
      Given { insert_dummy }
      Given { insert_key_file }
      Given { insert_dummy('./roro/stupid.env') }
      Given { insert_key_file('stupid.key') }
      Given { generate }

      # Then  { assert_file './roro/dummy.env.enc' }
      # And   { assert_file './roro/stupid.env.enc' }
    end
  end
end
