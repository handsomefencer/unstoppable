# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_exposed' do
  Given(:workbench) { 'roro' }
  Given(:envs)      { ['dummy'] }
  Given(:var_from_ENV) { dummy_key }
  Given(:generate) { Roro::CLI.new.generate_exposed(*envs) }

  Given { insert_dummy_env_enc }
  Given { insert_dummy_env_enc 'roro/env/smart.env.enc' }
  Given { insert_dummy_key }
  Given { insert_dummy_key 'smart.key' }

  context 'when one environment specified' do
    describe 'must only expose matching files' do
      # Given { quiet { generate } }
      Given { generate  }
      Then  { assert_file 'roro/env/dummy.env' }
      And   { refute_file 'roro/env/smart.env' }
    end

    describe 'with ENV_KEY' do
      describe 'expose one environment' do
        Given { with_env_set { quiet { generate } } }
        Then  { assert_file 'roro/env/dummy.env' }
      end
    end
  end
end
