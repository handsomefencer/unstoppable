# frozen_string_literal: true

require 'test_helper'

describe Roro::TestHelpers::RollonTestHelper do
  Given(:story_root) { "#{Roro::CLI.test_root}/fixtures/files/test_stacks/foxtrot" }
  Given(:story_path) { 'stacks/tailwind/sqlite/importmaps/okonomi' }
  Given(:options) { nil }
  Given(:subject) { RollonTestHelper.new("#{story_root}/#{story_path}", options) }

  describe '#initialize' do
    Given(:assert_correct_variables) do
      assert_equal story_root, subject.story_root
      assert_equal story_path, subject.story_path
      assert_equal "#{story_root}/#{story_path}", subject.dir
    end

    describe 'when stack is the active stack' do
      Given { debuggerer }
      Given(:story_root) { "#{Roro::CLI.test_root}/roro" }
      Then { assert_correct_variables }
    end

    describe 'when stack is a fixture stack' do
      Given(:story_root) { "#{Roro::CLI.test_root}/roro" }
      Then { assert_correct_variables }
    end

    describe 'when debugger not specified' do
      Then { refute subject.rollon_dummies }
      And { refute subject.rollon_loud }
    end

    describe 'when debugger false' do
      Given(:options) { { debuggerer: false } }
      Then { refute subject.rollon_dummies }
      And { refute subject.rollon_loud }
    end

    describe 'when debugger true' do
      Given(:options) { { debuggerer: true } }
      Then { assert subject.rollon_dummies }
      And { assert subject.rollon_loud }
    end
  end

  describe '#choices' do
    Given(:expected) { %w[stacks tailwind sqlite importmaps okonomi] }
    Then { assert_equal expected, subject.choices }
  end

  describe '#answers' do
    Then { assert_equal [6, 4, 3, 1], subject.answers }
  end

  describe '#manifests' do
    Then { assert_equal 2, subject.manifests.size }
    And { assert_match /stacks\/_manifest.yml/, subject.manifests.first }
    And { assert_match /okonomi\/_manifest.yml/, subject.manifests.last }
  end

  describe '#merge_manifests' do
    Given(:result) do
      subject.merge_manifests.dig(:tailwind,
        :"docker-compose.development.yml", 0,
        :services, :"watch-css", :container_name)
    end

    describe 'when not overriden' do
      When(:story_path) { 'stacks/tailwind/sqlite/importmaps/omakase' }
      Then { assert_equal "watch-css", result  }
    end

    describe 'when overriden' do
      Then { assert_equal "watch-child-override", result  }
    end
  end

  describe '#collect_dummies' do
    Then { assert_includes subject.dummies, '.gitignore' }
    And { assert_includes subject.dummies, 'Gemfile' }
  end

  describe '#rollon' do
    Given(:workbench) {}
    Given(:options) { { rollon_dummies: true, rollon_loud: true } }
    Given(:execute) { subject.rollon }

    describe 'when rollon_dummies: false must raise error' do
      Given(:options) { { rollon_dummies: false} }
      Then { assert_raises(RuntimeError) { execute } }
    end

    describe 'when rollon_dummies: true' do
      describe 'must capture dummy files' do
        Given { skip }
        Given { execute }
        Then { refute_match /usr\/src/, Dir.pwd }
        And { assert_match 'workbench', Dir.pwd }
        And { assert glob_dir('/**/*Gemfile').first }

        describe 'when dummies captured and rollon_dummies: false' do
          Given(:options) { { rollon_dummies: true } }
          Given { execute }
          Then { assert glob_dir('/**/*Gemfile').first }
        end
      end
    end
  end
end
