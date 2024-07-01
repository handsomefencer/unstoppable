# frozen_string_literal: true

require 'stack_test_helper'
require 'rake_test_helper'
require 'rake'
import "lib/tasks/ci/prepare/workflows/test.rake"

describe 'rake ci:prepare:workflows:test' do

  Given(:workbench) { 'active/test' }
  Given(:execute) { run_task('ci:prepare:workflows:test') }
  Given(:output) { capture_subprocess_io { execute }}
  # Given(:output) { with_captured_stdout { execute } }
      # run_task('ci:prepare:workflows:test') }}

  # Given { quiet { run_task('ci:config:pack') } }
  # Given { execute; output }
  Then do
    # assert_equal 1, globdir('tmp/ci/splits.txt').size
    # assert_content 'tmp/ci/splits.txt', /sqlite\/importmaps\/omakase/
  assert_equal 'blah', output  # assert_equal 'blah', globdir('test/ci/*').size
    # assert_equal 'barf', output.first.strip
    # assert_directory 'test/ci' #/ci/splits.txt'
  end
end
