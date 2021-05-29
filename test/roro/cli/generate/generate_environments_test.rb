# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_environments' do

  Given(:cli) { Roro::CLI.new }
  Given(:environments) { nil }
  Given(:workbench) { 'roro' }
  Given(:generate) { cli.generate_environments(*environments) }

  describe 'when non-directory file exists in workbench' do

    Given { insert_dummy_env 'dummy.smart.env' }
    Given { generate }

    Then { refute_file './roro/containers/dummy' }
  end

  context 'when no sibling folders and' do
    context 'when no environments supplied' do
      Given(:environments) { nil }
      Given { generate }

      describe 'must generate default containers' do

        Then { assert_directory './roro/containers/backend/scripts' }
      end

      describe 'must generate default .smart.env files ' do

        Then { assert_directory './roro/containers/frontend/smart.env/base.smart.env' }
      end

      describe 'must generate default keys' do

        Then { assert_file './roro/keys/base.key' }
      end
    end

    context 'when environments supplied' do
      Given(:workbench) { 'roro' }
      Given(:environments) { 'smart' }

      describe 'must generate default containers' do
        Given { generate }
        Then  { assert_directory './roro/containers/frontend/scripts' }
      end

      describe 'must generate specified .smart.env files ' do
        Given { generate }
        Then  { assert_file './roro/containers/frontend/smart.env/smart.smart.env' }
      end

      describe 'must generate specified keys' do
        Given { generate }
        Then  { assert_file './roro/keys/smart.key' }
      end
    end
  end

  context 'when sibling folders and' do
    Given(:workbench) { %w[roro pistil stamen] }

    context 'when no environments supplied' do
      Given(:environments) { nil }

      describe 'must generate sibling containers' do
        Given { generate }
        Then  { assert_directory './roro/containers/stamen/scripts' }
      end

      describe 'must generate default .smart.env files in sibling containers ' do
        Given { generate }
        Then  { assert_directory './roro/containers/pistil/smart.env/base.smart.env' }
      end

      describe 'must generate default keys' do
        Given { generate }
        Then  { assert_file './roro/keys/base.key' }
      end
    end

    context 'when environments supplied' do
      Given(:environments) { 'smart' }

      describe 'must generate default containers' do
        Given { generate }
        Then  { assert_directory './roro/containers/stamen/scripts' }
      end

      describe 'must generate specified .smart.env files ' do
        Given { generate }
        Then  { assert_file './roro/containers/pistil/smart.env/smart.smart.env' }
      end

      describe 'must generate specified keys' do
        Given { generate }
        Then  { assert_file './roro/keys/smart.key' }
      end
    end
  end
end
