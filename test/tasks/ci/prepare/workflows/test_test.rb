# frozen_string_literal: true

require 'rake_test_helper'

describe 'rake ci:prepare:workflows:test' do
  Given(:workbench) { 'active/test' }
  Given(:stacks) { ".circleci/splits/testfiles_stacks.txt"}
  Given(:roro) { ".circleci/splits/testfiles_roro.txt"}
  Given { Rake::TaskArguments.any_instance.stubs(:extras).returns(args) }
  Given(:args) { nil }
  Given(:execute) { run_task('ci:prepare:workflows:test', args) }

  Given { execute }

  describe 'without arguments' do
    Then do
      assert_equal 1, globdir(roro).size
      assert_equal 1, globdir(stacks).size
      assert_content stacks, /bootstrap\/sqlite\/importmaps\/okonomi/
    end
  end

  describe 'without one argument' do
    When(:args) { ['sqlite importmaps okonomi ; tailwind bun omakase'] }

    Then do
      assert_equal 1, globdir(stacks).size
      assert_equal 1, globdir(roro).size
      assert_content stacks, /bootstrap\/sqlite\/importmaps\/okonomi/
      assert_content stacks, /tailwind\/sqlite\/importmaps\/okonomi/
      assert_content stacks, /tailwind\/sqlite\/bun\/omakase/
      refute_content stacks, /sass\/sqlite\/bun\/okonomi/
    end
  end
end
