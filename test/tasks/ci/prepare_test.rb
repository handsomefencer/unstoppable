# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare' do
  Given(:workbench) { '.circleci' }
  Given(:workflow)  { '.circleci/src/workflows/test-matrix-rollon.yml' }
  Given(:config)    { '.circleci/config.yml' }
  Given { run_task('ci:prepare') }

  Then do
    assert_file workflow, /test-rollon/
    assert_file workflow, /answers:\n/
    assert_file workflow, /- 1\\n1\n/
    assert_match 'Wrote answers', @output.first
  end
end