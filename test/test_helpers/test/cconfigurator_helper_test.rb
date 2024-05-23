# frozen_string_literal: true

require 'test_helper'

describe 'Roro::TestHelpers::ConfiguratorHelper' do
  Given(:subject) { Rollon.getsome("#{Roro::CLI.test_root}/roro/stacks/#{stack}") }
  Given(:stack) { "tailwind/sqlite/importmaps/okonomi" }

  describe '#initialize' do
    Then do
      assert_match /okonomi/, subject.dir
      assert_equal subject.roro_test_root, "/usr/src/test/roro"
      assert_equal subject.stack_test_root, "/usr/src/test/roro/stacks"
      assert_equal subject.filematchers, %w[okonomi importmaps sqlite tailwind stacks]
      assert_equal subject.choices, %w[tailwind sqlite importmaps okonomi]
      assert_includes subject.dummyfiles, '.gitignore'
      assert_equal subject.answers, [6,4,3,1]
    end
  end

  describe '#gather_manifests' do
    Then { assert_equal subject.gather_manifests.size, 2 }
  end

  describe '#merge_manifests' do
    Given(:result) do
      subject.merge_manifests.dig(:tailwind,
        :"docker-compose.development.yml", 0,
        :services, :"watch-css", :container_name)
    end

    describe 'when not overriden in child file' do
      Given(:stack) { "tailwind/sqlite/vite/okonomi" }
      Then { assert_equal "watch-css", result  }

    end

    describe 'when overriden in child file' do
      Then { assert_equal "watch-oops", result  }
    end
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
