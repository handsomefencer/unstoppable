# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_exposed' do
  before(:all) do
    prepare_destination 'roro'
    Thor::Shell::Basic.any_instance.stubs(:ask).returns('y')
  end

  Given(:cli) { Roro::CLI.new }

  Given(:setup_with_encrypted_files) do
    %w[development dummy staging production].each do |e|
      insert_dummy_decryptable("./roro/env/#{e}.env.enc")
      insert_dummy_decryptable("./roro/containers/app/#{e}.env.enc")
    end
  end

  context 'when one environment specified' do
    Given { setup_with_encrypted_files }

    describe 'must only expose matching files' do
      Given { insert_key_file('production.key')}
      Given { cli.generate_exposed 'production' }

      Then { assert_file 'roro/env/production.env' }
      And  { assert_file 'roro/containers/app/production.env' }
      And  { refute_file 'roro/env/development.env' }
    end

    describe 'with ENV_KEY' do
      Given(:var_from_ENV) {
        File.read("#{ENV['PWD']}/test/fixtures/files/dummy_key").strip}

      describe 'expose one environment' do

        Then do
          with_env_set do
            cli.generate_exposed 'dummy'
            assert_file 'roro/containers/app/dummy.env'
          end
        end
      end
    end
  end
end
