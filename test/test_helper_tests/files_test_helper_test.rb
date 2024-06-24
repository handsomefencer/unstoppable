# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::TestHelpers::FilesTestHelper do
  describe '#globdir(regex)' do
    Given(:workbench) { 'crypto' }
    Given(:expected) { /entrypoint.sh/ }
    Given(:regex) { "**/*.sh" }
    Given(:path) { "crypto/roro/scripts" }
    Given(:result) { globdir(regex, path) }

    describe 'when default and workbench' do
      Given(:regex) { nil }
      Given(:path) { nil }

      describe 'has files' do
        Then { refute_empty result }
      end

      describe 'is empty' do
        Given(:workbench) { }
        Then { assert_empty result }
      end
    end

    describe 'when file matches regex and path' do
      Then { assert_match expected, result.first }
    end

    describe 'when file matches regex but not in path' do
      Given(:path) { "crypto/roro/env" }
      Then { assert_empty result}
    end

    describe 'when file does not match regex but matches path' do
      Given(:regex) { "**/*.pdf" }
      Then { assert_empty result }
    end

    describe 'when regex is nil and file in path' do
      Given(:regex) { nil }
      Then { assert_match expected, result.first }
    end

    describe 'when path does not exist' do
      Given(:path) { 'crypto/nomicon'}
      Then { assert_empty result }
    end

    describe 'when regex nil and no matching path' do
      Then { refute globdir(nil, 'crypto/nomicon').first }
    end
  end
end
