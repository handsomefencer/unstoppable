require "test_helper"

describe Roro::CLI do
  Given { prepare_destination 'roro' }
  Given { Thor::Shell::Basic.any_instance.stubs(:ask).returns('y') }
  Given(:error) { Roro::Error }
  Given(:cli)   { Roro::CLI.new }

  describe '#generate_key(*args)' do
    describe '#gather_environments' do
      Given(:result) { cli.gather_environments }

      context 'when .env file in roro/env/' do
        Given { insert_dotenv('roro/env/development.env') }

        Then { assert_includes result, 'development' }
      end

      context 'when .env file in roro/containers/database/env/' do
        Given { insert_dotenv('roro/containers/database/env/development.env') }

        Then { assert_includes result, 'development' }
      end

      context 'when .env file in roro/containers/database/' do
        Given { insert_dotenv('roro/containers/database/env/development.env') }

        Then { assert_includes result, 'development' }
      end

      context 'when .env file has subenv' do
        Given { insert_dotenv('roro/containers/database/env/test.1.env') }

        Then { assert_equal result, 'development' }
      end

    end
  end



  # Given(:envs) { %w(development staging production) }
  # Given(:dotenv_dir) { 'roro/containers/app/' }
  # Given { insert_dot_env_files(envs) }

  # def keys_folder_empty
  #   refute_file 'roro/keys/ci.key'
  #   refute_file 'roro/keys/production.key'
  #   refute_file 'roro/keys/staging.key'
  #   refute_file 'roro/keys/development.key'
  # end

  # describe 'new roro directory must not have keys' do

  #   Then { keys_folder_empty }
  # end

  # describe "gather_environments" do

  #   Given(:actual) { cli.gather_environments }

  #   Then { envs.each { |env| assert_includes actual, env } }
  # end

  # describe 'generate_key' do
  #   describe 'with env specified' do

  #     Given { cli.generate_key('ci') }

  #     describe 'must only generate the specified key' do

  #       Then { assert_file 'roro/keys/ci.key' }
  #       And  { refute_file 'roro/keys/production.key' }
  #     end
  #   end

  #   describe 'without env specified' do
  #     describe 'must generate key even without env.env files' do
  #       Given(:env_with_no_env)  { 'no_dot_env_environment' }
  #       Given { cli.generate_key env_with_no_env }

  #       Then { assert_file "roro/keys/#{env_with_no_env}.key" }
  #     end

  #     describe 'must generate keys when env.env exists' do

  #       Given { cli.generate_key }

  #       Then { envs.each { |e| assert_file "roro/keys/#{e}.key" } }
  #     end
  #   end
  # end

  # describe '.confirm_files_decrypted()' do
  #   describe 'without either .env or .env.enc' do

  #     Then { assert cli.confirm_files_decrypted?('circleci') }
  #   end

  #   describe 'when just a .env file present' do

  #     Given { cli.generate_key }

  #     Then { assert cli.confirm_files_decrypted?('circleci') }

  #     describe "when .env.enc file has no matching .env file" do

  #       Given { cli.generate_obfuscated }
  #       Given { remove_dot_env_files(['development']) }
  #       Given { refute_file 'roro/containers/app/development.env' }

  #       Then do
  #         assert_raises(error) { cli.confirm_files_decrypted? 'development'}
  #       end

  #       describe "when called from generate_key" do

  #         Then { assert_raises( error ) { cli.generate_key 'development' } }
  #       end

  #       describe "when called from generate_key" do

  #         Then { assert_raises( error ) { cli.generate_key } }
  #       end
  #     end
  #   end
  # end
end