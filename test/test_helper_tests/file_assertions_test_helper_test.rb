# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::TestHelpers::FileAssertionsTestHelper do
  Given(:workbench) { '.circleci' }

  describe '#assert_file_match_in' do
    Given(:files) { ['somefile.rb', 'some/file.rb'] }

    describe 'when matcher is for file' do
      Given(:matcher) { 'somefile' }
      Then { assert_file_match_in(matcher, files) }
    end

    describe 'when matcher is for directory' do
      Given(:matcher) { 'some' }
      Then { assert_file_match_in(matcher, files) }
    end
  end

  describe 'file expectations' do
    Given(:expected_file) { '.circleci/src/@config.yml' }
    Given(:unexpected_file) { '.circleci/src/unexpected.yml' }

    describe '#assert_file()' do
      describe 'when file path exact' do
        Then { assert_file expected_file }
        And { assert assert_file(expected_file) }
      end

      describe 'when file path matches' do
        Then { assert_file '.circleci/src' }
        And { assert assert_file(expected_file) }
      end
    end

    describe '#assert_directory()' do
      Then { assert_directory expected_file }
      And { assert assert_directory(expected_file) }
    end

    describe '#refute_file()' do
      Then { refute_file(unexpected_file) }
      And { assert refute_file(unexpected_file) }
    end

    describe '#refute_directory()' do
      Then { refute_directory unexpected_file }
      And { assert refute_directory(unexpected_file) }
    end
  end
  # describe '#assert_content(file, *contents); assert_directory(directory)' do
  #   Given(:expected) { '.circleci/src/@config.yml' }
  #   Given(:unexpected) { '.circleci/src/unexpected.yml' }

  #   describe 'when full path matches' do
  #     Then { assert_file expected }
  #     And { assert_directory expected }
  #   end

  #   describe 'when partial path matches' do
  #     Given(:expected) { '.circleci/src' }
  #     Then { assert_file expected }
  #     And { assert_directory expected }
  #   end

  #   describe 'when content passed as regex' do
  #     Then { assert_content expected, /version/ }
  #     And { assert_directory expected }
  #     And { refute_content expected, /vershun/ }
  #   end

  #   describe 'when content passed as string' do
  #     Then { assert_content expected, 'version: 2.1' }
  #     And { assert_directory expected }
  #     And { refute_content expected, 'version: 1.2' }
  #     And { refute_content expected, 'version: 1.2' }
  #   end
  # end

  # describe '#assert_file(file); assert_directory(directory)' do
  #   Given(:expected) { '.circleci/src/@config.yml' }
  #   Given(:unexpected) { '.circleci/src/unexpected.yml' }

  #   describe 'when full path matches' do
  #     Then { assert_file expected }
  #     And { assert_directory expected }
  #   end

  #   describe 'when partial path matches' do
  #     Given(:expected) { '.circleci/src' }
  #     Then { assert_file expected }
  #     And { assert_directory expected }
  #   end

  #   describe 'when content passed as regex' do
  #     Then { assert_content expected, /version/ }
  #     And { assert_directory expected }
  #     And { refute_content expected, /vershun/ }
  #   end

  #   describe 'when content passed as string' do
  #     Then { assert_content expected, 'version: 2.1' }
  #     And { assert_directory expected }
  #     And { refute_content expected, 'version: 1.2' }
  #     And { refute_content expected, 'version: 1.2' }
  #   end
  # end

  describe '#assert_yaml(*args) #refute_yaml(*args)' do
    Given(:file) { '.circleci/src/workflows/gem-release.yml' }

    describe 'When last arg is a string' do
      Then { assert_yaml(file, :jobs, :release, 'foobar') }
      And { refute_yaml(file, :jobs, :release, 'bar') }
    end

    describe 'When last arg is a regex' do
      Then { assert_yaml(file, :jobs, :release, /foo/) }
      And { refute_yaml(file, :jobs, :release, /qux/) }
    end

    describe 'When last arg is a hash' do
      Given(:expected) { { jobs: { release: 'foobar'  } } }
      Given(:unexpected) { { jobs: { release: 'bazqux'  } } }

      Then { assert_yaml(file, expected) }
      And { refute_yaml(file, unexpected) }
    end
  end
end
