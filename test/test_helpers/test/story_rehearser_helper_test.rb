# frozen_string_literal: true

require 'test_helper'

describe 'Roro::TestHelpers::ConfiguratorHelper' do

  Given(:story_root) { "#{Roro::CLI.test_root}/fixtures/files/test_stacks/foxtrot" }
  Given(:story_path) { 'stacks/tailwind/sqlite/importmaps/okonomi' }
  Given(:subject) { StoryRehearser.new("#{story_root}/#{story_path}") }

  describe '#initialize' do
    Given(:assert_correct_variables) do
      assert_equal story_root, subject.story_root
      assert_equal story_path, subject.story_path
      assert_equal "#{story_root}/#{story_path}", subject.dir
    end

    describe 'when stack is the active stack' do
      Given(:story_root) { "#{Roro::CLI.test_root}/roro" }
      Then { assert_correct_variables }
    end

    describe 'when stack is a fixture stack' do
      Given(:story_root) { "#{Roro::CLI.test_root}/roro" }
      Then { assert_correct_variables }
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

    describe 'when not overriden in child file' do
      When(:story_path) { 'stacks/tailwind/sqlite/importmaps/omakase' }
      Then { assert_equal "watch-css", result  }
    end

    describe 'when overriden in child file' do
      Then { assert_equal "watch-child-override", result  }
    end
  end

  describe '#collect_dummyfiles' do
    Given(:result) { subject.collect_dummyfiles }
    Then { assert_includes subject.dummyfiles, '.gitignore' }
    And { assert_includes result, 'Gemfile' }
  end

  describe '#glob_dir(regex)' do
    # Given { set_workbench('echo') }
    # Then { assert_match /ruby/, glob_dir('**/*ruby.yml').first }
  end

  describe '#set_workench(dir)' do
    # Given { set_workbench('echo') }
    # Then { assert_match /echo/, Dir.pwd }
  end

  describe '#use_fixture_stack(stack)' do
    # Given { use_fixture_stack('echo') }
    # Then { assert_match /echo/, Roro::CLI.stacks }
  end

  describe '#debuggerer' do
    # Given { debuggerer }
    # Then { assert @rollon_dummies }
  end
  describe '#copy_stage_dummy' do
# path
#   "/usr/src/test/roro/stacks/tailwind/sqlite/importmaps/okonomi"

#  Dir.pwd
# "/tmp/d20240522-630-czvdnp/workbench"

  end
end
