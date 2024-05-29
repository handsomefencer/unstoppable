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

  describe '#assert_file(file, *contents); #refute_file(file, *contents)' do
    Given(:expected) { '.circleci/src/@config.yml' }
    Given(:unexpected) { '.circleci/src/unexpected.yml' }

    describe 'when full path matches' do
      Then { assert_file expected }
      And { assert_directory expected }
    end

    describe 'when partial path matches' do
      Given(:expected) { '.circleci/src' }
      Then { assert_file expected }
      And { assert_directory expected }
    end

    describe 'when content passed as regex' do
      Then { assert_file expected, /version/ }
      And { assert_directory expected }
      And { refute_file expected, /vershun/ }
    end

    describe 'when content passed as string' do
      Then { assert_file expected, 'version: 2.1' }
      And { assert_directory expected }
      And { refute_file expected, 'version: 1.2' }
      And { refute_content expected, 'version: 1.2' }
    end
  end

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
