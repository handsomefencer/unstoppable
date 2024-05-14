# frozen_string_literal: true

require 'test_helper'

describe '3 Postgres -> 3 importmap -> 2 omakase' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

focus
  Then { assert_correct_manifest(__dir__) }

  describe 'will not have dockerfile node cache' do
    Given(:file) { 'mise/containers/app/Dockerfile.builder.cache' }
    Given(:content) { 'mise/containers/app/Dockerfile.builder.cache' }

    Then do
      assert_file(file, /RUN bundle update --bundler/)
      refute_content(file, /COPY package.json yarn.lock/)
    end
  end

end
