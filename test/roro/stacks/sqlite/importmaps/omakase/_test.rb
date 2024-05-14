# frozen_string_literal: true

require 'test_helper'

describe '4 SQLite -> 3 Importmaps -> 2 omakase' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  focus
  Then { assert_correct_manifest(__dir__) }

  describe 'will not have db container' do
    Then do
      assert 'mise/containers/app'
      refute_file 'mise/containers/db'
    end
  end

  describe 'will not have db service' do
    Then do
      assert_file('docker-compose.vendor.yml', /roro:/)
      refute_content('docker-compose.vendor.yml', /db:/)
    end
  end

  describe 'will not have dockerfile node cache' do
    Given(:file) { 'mise/containers/app/Dockerfile.builder.cache' }
    Given(:content) { 'mise/containers/app/Dockerfile.builder.cache' }

    Then do
      assert_file(file, /RUN bundle update --bundler/)
      refute_content(file, /COPY package.json yarn.lock/)
    end
  end
end
