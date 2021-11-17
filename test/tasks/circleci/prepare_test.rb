# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare' do
  Given(:workbench) { '.circleci' }
  Given(:run_task)  { Rake.application.invoke_task 'circleci:prepare' }
  Given(:workflow)  { '.circleci/src/workflows/test-matrix-rollon.yml' }
  Given(:config)    { '.circleci/config.yml' }
  Given!(:output)   { capture_subprocess_io { run_task } }

  Then do
    assert_file workflow, /test-rollon/
    assert_file workflow, /answers:\n/
    assert_file workflow, /- 1\\n1\n/
    assert_match 'Wrote answers', output.first
    assert_match 'Packing', output.first
    assert_match 'Packed', output.first
    assert_match 'Validating', output.first
    assert_match 'is valid', output.first
  end
end