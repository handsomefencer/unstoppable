# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_exposed' do
  Given(:subject)   { Roro::CLI.new }
  Given(:workbench) { 'roro' }

  context 'when one environment specified' do
    Given { insert_dummy_env_enc }
    Given { insert_dummy_env_enc 'roro/env/smart.env.enc' }

    describe 'must only expose matching files' do
      Given { insert_dummy_key }
      Given { insert_dummy_key 'smart.key' }
      Given { subject.generate_exposed 'dummy' }

      Then { assert_file 'roro/env/dummy.env' }
      And  { assert_file 'roro/env/dummy.env.enc' }
      And  { assert_file 'roro/env/smart.env.enc' }
      And  { refute_file 'roro/env/smart.env' }
    end

    describe 'with ENV_KEY' do
      Given(:var_from_ENV) { dummy_key }

      describe 'expose one environment' do
        Then do
          with_env_set do
            subject.generate_exposed 'dummy'
            assert_file 'roro/env/dummy.env'
          end
        end
      end
    end
  end
end
