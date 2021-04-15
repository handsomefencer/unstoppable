require "test_helper"

describe Roro::CLI do
  Given { prepare_destination 'roro' }
  Given { Thor::Shell::Basic.any_instance.stubs(:ask).returns('y') }
  Given(:error) { Roro::Error }
  Given(:cli)   { Roro::CLI.new }

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

    context 'when .env file has subenv must name key after environment' do
      Given { insert_dotenv('roro/containers/database/env/test.1.env') }

      Then { assert_includes result, 'test' }
    end
  end

  describe 'generate_keys' do
    context 'when environment specified' do
      # Given(:generated_keys) {
      #   assert_file 'roro/keys/ci.key'
      #   refute_file 'roro/keys/production.key' }
      Given { cli.generate_key('ci') }

      describe 'must only generate the specified key' do

        # Then { assert_file 'roro/keys/ci.key' }
        # And  { refute_file 'roro/keys/production.key' }
      end
    end

    describe 'when key with name exists' do
      Given { cli.generate_key('ci') }
      Then  do
        assert_raises Roro::Error do
          cli.generate_key('ci' )
        end
      end
    end

    describe 'must generate keys when env.env exists' do

      Given { cli.generate_key }

      # Then { envs.each { |e| assert_file "roro/keys/#{e}.key" } }
    end
  end

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