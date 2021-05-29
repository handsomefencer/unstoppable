# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_exposed' do
  Given(:dummy_apps) { 'roro' }
  Given(:cli) { Roro::CLI.new }

  Given(:setup_with_encrypted_files) do
    %w[dummy].each do |e|
      insert_dummy_env_enc("roro/env/#{e}.env.enc")
      # insert_dummy_env_enc("roro/containers/app/#{e}.env.enc")
      # assert_file "./roro/env/#{e}.env.enc"
      # insert_dummy_env_enc("./roro/containers/fron/env/#{e}.env.enc")
    end
  end

  context 'when one environment specified' do
    Given { setup_with_encrypted_files }

    describe 'must only expose matching files' do
      Given { insert_dummy_key }
      # Given { insert_key_file('production.key')}
      Given { cli.generate_exposed 'dummy' }

      Then { assert_file 'roro/env/dummy.env' }
      # And  { assert_file 'roro/containers/app/production.env' }
      # And  { refute_file 'roro/env/development.env' }
    end

    describe 'with ENV_KEY' do
      Given(:var_from_ENV) {
        File.read("#{ENV['PWD']}/test/fixtures/files/dummy_key").strip }

      describe 'expose one environment' do
        # before { skip }
        # Then do
        #   with_env_set do
        #     cli.generate_exposed 'dummy'
        #     assert_file 'roro/containers/app/dummy.env'
        #   end
        # end
      end
    end
  end
end
