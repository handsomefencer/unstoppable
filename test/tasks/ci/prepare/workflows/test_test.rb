# frozen_string_literal: true

require 'rake_test_helper'

describe 'rake ci:prepare:workflows:test' do
  Given(:workbench) { 'active/test' }
  Given(:stacks) { ".circleci/splits/testfiles_stacks.txt"}
  Given(:roro) { ".circleci/splits/testfiles_roro.txt"}
  Given(:args) { ['ci:prepare:workflows:test'] }
  Given(:execute) { run_task(*args) }

  describe 'without arguments' do
    Given { execute }
    Then do
      assert_equal 1, globdir(roro).size
      assert_equal 1, globdir(stacks).size
      assert_content stacks, /bootstrap\/sqlite\/importmaps\/okonomi/
    end
  end

  describe 'with one argument' do
    Given { args << 'sqlite importmaps okonomi ; tailwind bun omakase' }
    Given { execute }
    Then do
      assert_equal 1, globdir(stacks).size
      assert_equal 1, globdir(roro).size
      assert_content stacks, /bootstrap\/sqlite\/importmaps\/okonomi/
      assert_content stacks, /tailwind\/sqlite\/importmaps\/okonomi/
      assert_content stacks, /tailwind\/sqlite\/bun\/omakase/
      refute_content stacks, /sass\/sqlite\/bun\/okonomi/
      refute_content stacks, /bootstrap\/sqlite\/bun\/okonomi/
    end
  end
end
