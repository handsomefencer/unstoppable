# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_environments' do
  before(:all) do
    Thor::Shell::Basic.any_instance.stubs(:ask).returns('y')
  end

  Given(:cli)      { Roro::CLI.new }
  Given(:generate) { cli.generate_environments(*environments) }

  context 'when no sibling folders and' do
    Given { prepare_destination('roro') }

    context 'when no environments supplied' do
      Given(:environments) { nil }
      Given { generate }

      describe 'must generate default containers' do

        Then { assert_directory './roro/containers/backend/scripts' }
      end

      describe 'must generate default .env files ' do

        Then { assert_directory './roro/containers/frontend/env/base.env' }
      end

      describe 'must generate default keys' do

        Then { assert_file './roro/keys/base.key' }
      end
    end

    context 'when environments supplied' do
      Given(:environments) { 'smart' }
      Given { generate }

      describe 'must generate default containers' do

        Then { assert_directory './roro/containers/frontend/scripts' }
      end

      describe 'must generate specified .env files ' do

        Then { assert_file './roro/containers/frontend/env/smart.env' }
      end

      describe 'must generate specified keys' do

        Then { assert_file './roro/keys/smart.key' }
      end
    end
  end

  context 'when sibling folders and' do
    Given { prepare_destination('roro', 'pistil', 'stamen') }

    context 'when no environments supplied' do
      Given(:environments) { nil }
      Given { generate }

      describe 'must generate sibling containers' do

        Then { assert_directory './roro/containers/stamen/scripts' }
      end

      describe 'will not generate sibling container for a file' do
        Given { insert_file 'dummy_env', './dummy.env'  }
        Given { assert_file './dummy.env' }

        Then { refute_file './roro/containers/dummy'}
      end

      describe 'must generate default .env files in sibling containers ' do

        Then { assert_directory './roro/containers/pistil/env/base.env' }
      end

      describe 'must generate default keys' do

        Then { assert_file './roro/keys/base.key' }
      end
    end

    context 'when environments supplied' do
      Given(:environments) { 'smart' }
      Given { generate }

      describe 'must generate default containers' do

        Then { assert_directory './roro/containers/stamen/scripts' }
      end

      describe 'must generate specified .env files ' do

        Then { assert_file './roro/containers/pistil/env/smart.env' }
      end

      describe 'must generate specified keys' do

        Then { assert_file './roro/keys/smart.key' }
      end
    end
  end
end