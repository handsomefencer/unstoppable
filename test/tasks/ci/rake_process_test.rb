# # frozen_string_literal: true
#
# require 'test_helper'
# require 'rake'
#
# describe 'rake ci:process' do
#   Given(:workbench) { '.circleci' }
#   Given(:run_task)  { tasks.each { |t| Rake.application.invoke_task t } }
#   Given(:workflow)  { '.circleci/src/workflows/test-matrix-rollon.yml' }
#   Given { quiet { run_task } }
#
#   describe 'must create workflow from template' do
#     Given(:tasks)     { ['ci:process'] }
#     Then { assert_file workflow, /test-rollon/ }
#     And  { assert_file workflow, /answers:\n/ }
#     And  { assert_file workflow, /- 1\\n1\n/ }
#   end
# end