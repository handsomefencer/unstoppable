# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_keys' do
  Given { Thor::Shell::Basic.any_instance.stubs(:ask).returns('y') }
  Given(:cli) { Roro::CLI.new }

  describe '#generate_keys' do
    context 'when no environments supplied and' do
      Given { prepare_destination 'roro' }

      Given(:generate) { cli.generate_keys }

      context 'when no .smart.env files' do
        Given(:error) { Roro::Crypto::EnvironmentError }

        Then { assert_raises(error) { generate } }
      end

      context 'when one .smart.env file' do
        Given { insert_dummy_env }
        Given { generate }

        Then  { assert_file('roro/keys/dummy.key') }
      end

      context 'when two different .smart.env files' do
        Given { insert_dummy_env }
        Given { insert_dummy_env('./roro/stupid.smart.env') }
        Given { generate }

        Then  { assert_file('roro/keys/dummy.key') }
        And   { assert_file('roro/keys/stupid.key') }
      end
    end

    context 'when one environment supplied' do
      Given(:generate) { cli.generate_keys('dummy') }

      context 'when no key matches environment' do
        Given { generate }

        Then  { assert_file('roro/keys/dummy.key') }
      end
    end

    context 'when two environments supplied' do
      Given { cli.generate_keys('dummy', 'smart') }

      Then  { assert_file('roro/keys/dummy.key') }
      And   { assert_file('roro/keys/smart.key') }
    end
  end
end