# frozen_string_literal: true

require 'test_helper'

describe '4 SQLite -> 1 Bun -> 2 omakase' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end
  Then { assert_correct_manifest(__dir__) }

  describe 'dockerfiles' do
    describe 'builder.cache' do
      Then do
        refute_content('mise/containers/app/Dockerfile.builder.cache', /yarn/)
      end
    end

    describe 'builder.deps.dev' do
      Given(:file) { 'mise/containers/app/Dockerfile.builder.deps.dev' }
      Then do
        refute_content(file, /node/)
      end
    end

    describe 'builder.deps.dev' do
      Given(:file) { 'mise/containers/app/Dockerfile.development' }
      Then do
        refute_content(file, /COPY package.json/)
      end
    end
  end
end
