# frozen_string_literal: true

require 'test_helper'

describe Roro::TestHelpers::FilesTestHelper do
  describe '#glob_dir(regex)' do
    Given(:workbench) { 'crypto' }
    Given(:expected) { /entrypoint.sh/ }
    Given(:regex) { "**/*.sh" }
    Given(:path) { "crypto/roro/scripts" }
    Given(:result) { globdir(regex, path) }

    describe 'when default' do
      Given(:regex) { nil }
      Given(:path) { nil }

      describe 'when workbench has files' do
        Then { refute_empty result }
      end

      describe 'when workbench has no files' do
        Given(:workbench) { }
        Then { assert_empty result}
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

    # Given(:args) { nil }
    # Given(:result) { globdir(*args).first }

    # describe 'when default and workbench is empty' do
    #   focus
    #   Then { assert_empty result}
    # end

    # describe 'when default must find all files' do
    #   Given(:workbench) { 'crypto' }
    #   # focus
    #   Then { refute_empty globdir }
    # end

    # describe 'when regex specified' do
    #   Given(:args) { ["**/*.sh"] }
# focus
      # Then { assert_match expected, result }
    # end

    # describe 'when regex and path specified' do
    #   Given(:path) { 'crypto/roro'}
    #   Then { assert_match expected, result }

    #   describe 'when file is not in path' do
    #     Given(:path) { 'crypto/roro/scripts'}
    #     Then { assert_nil result }
    #   end
    # end

  end
end
