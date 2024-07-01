# frozen_string_literal: true

require 'rake_test_helper'

describe 'rake ci:prepare:workflows:test' do
  Given(:workbench) { 'active/test' }
  Given(:execute) { run_task('ci:prepare:workflows:test') }
  Then do
    execute
    assert_equal 3, globdir('test/roro/stacks/**/*_test.rb').size
    assert_equal 1, globdir('.circleci/splits/testfiles_roro.txt').size
    assert_equal 1, globdir('.circleci/splits/testfiles_stacks.txt').size
    assert_content '.circleci/splits/testfiles_stacks.txt', /sqlite\/importmaps\/omakase/
    refute_content '.circleci/splits/testfiles_stacks.txt', /test\/fixtures/
    refute_content '.circleci/splits/testfiles_roro.txt', /sqlite\/importmaps\/omakase/
    refute_content '.circleci/splits/testfiles_roro.txt',  /test\/fixtures/
  end
end
