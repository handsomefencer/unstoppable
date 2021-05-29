# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_environments' do
  let(:subject)              { Roro::CLI.new }
  let(:workbench)            { 'roro' }
  let(:default_apps)         { %w[backend database frontend] }
  let(:default_environments) { %w[base development test staging production] }
  let(:environments)         { nil }
  let(:generate)             { subject.generate_environments(*environments) }

  describe 'when non-directory file exists in workbench' do

    Given { insert_dummy_env 'dummy.smart.env' }
    Given { generate }
    Then  { refute_file 'roro/containers/dummy' }
  end

  describe 'when hidden directory exists in workbench' do
    let(:workbench) { %w[roro .dotfolder] }

    Given { generate }
    Then  { refute_file 'roro/containers/.dotfolder' }
  end

  context 'when no sibling folders and' do
    context 'when no environments supplied' do
      let(:environments) { nil }

      Given { generate }

      describe 'must generate default containers' do

        Then { assert_directory 'roro/containers/backend/scripts' }
      end

      describe 'must generate default .smart.env files ' do
        Then do
          default_apps.each do |a|
            default_environments.each do |e|
              assert_file "roro/containers/#{a}/env/#{e}.env"
            end
          end
        end
      end

      describe 'must generate default keys' do

        Then { assert_file 'roro/keys/base.key' }
      end
    end

    context 'when environments supplied' do
      let(:workbench)    { 'roro' }
      let(:environments) { 'smart' }

      Given { generate }

      describe 'must generate default containers' do

        Then  { assert_directory 'roro/containers/frontend/scripts' }
      end

      describe 'must generate specified .env files ' do

        Then  { assert_file 'roro/containers/frontend/env/smart.env' }
      end

      describe 'must generate specified keys' do

        Then  { assert_file 'roro/keys/smart.key' }
      end
    end
  end

  context 'when sibling folders and' do
    let(:workbench) { %w[roro pistil stamen] }

    context 'when no environments supplied' do
      let(:environments) { nil }

      Given { generate }

      describe 'must generate sibling containers' do

        Then  { assert_directory 'roro/containers/stamen/scripts' }
      end

      describe 'must generate default .smart.env files in sibling containers ' do
        Then  { assert_directory 'roro/containers/pistil/env/base.env' }
      end

      describe 'must generate default keys' do

        Then  { assert_file 'roro/keys/base.key' }
      end
    end

    context 'when environments supplied' do
      let(:environments) { 'smart' }

      Given { generate }

      describe 'must generate default containers' do

        Then  { assert_directory 'roro/containers/stamen/scripts' }
      end

      describe 'must generate specified .smart.env files ' do

        Then  { assert_file 'roro/containers/pistil/env/smart.env' }
      end

      describe 'must generate specified keys' do

        Then  { assert_file 'roro/keys/smart.key' }
      end
    end
  end
end
