# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:pack' do
  # Given(:workbench) { '.circleci' }
  Given(:task) { 'ci:pack' }
  Given { Rake.application.load_rakefile }
  Given { Rake.application.invoke_task task }

  Given(:workflow) { '.circleci/src/workflows/test-matrix-rollon.yml' }

  Then { assert_file '.circleci/config.yml' }
  # Then { assert_file workflow, /answers:/ }
end
