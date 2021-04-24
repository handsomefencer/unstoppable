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

      # Then { assert_includes result, 'development' }
    end

    context 'when .env file in roro/containers/database/env/' do
      Given { insert_dotenv('roro/containers/database/env/development.env') }

      # Then { assert_includes result, 'development' }
    end

    context 'when .env file in roro/containers/database/' do
      Given { insert_dotenv('roro/containers/database/env/development.env') }

      # Then { assert_includes result, 'development' }
    end

    context 'when .env file has subenv must name key after environment' do
      Given { insert_dotenv('roro/containers/database/env/test.1.env') }

      # Then { assert_includes result, 'test' }
    end
  end

  describe 'generate_keys' do
    context 'when environment specified' do
      Given { cli.generate_key('ci') }

      describe 'must generate the specified key' do

        Then { assert_file 'roro/keys/ci.key' }
      end

      context 'when key with name exists' do

        Invariant { assert_file 'roro/keys/ci.key' }

        Then  { assert_raises(Roro::Error) { cli.generate_key('ci' ) } }
      end
    end

    context 'when environments inferred' do

      Given { insert_dotenv('roro/containers/database/env/test.1.env') }
      Given { cli.generate_keys }

      # Then { assert_file 'roro/keys/test.key' }
      # And  { refute_file 'roro/keys/test.1.key' }
    end

    context 'when no environment specified or inferrable' do

      Then  { assert_raises(Roro::Error) { cli.generate_keys } }
    end
  end
end