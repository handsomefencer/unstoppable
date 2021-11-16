# # frozen_string_literal: true
#
# require 'test_helper'
# require 'rake'
#
# describe 'rake ci:pack' do
#   Given!(:workbench) { '.circleci' }
#   Given(:task)      { 'ci:config:pack' }
#   Given(:run_task)  { Rake.application.invoke_task task }
#
#   Given { quiet { run_task } }
#
#   describe 'must create workflow from template' do
#     Then { assert_file '.circleci/config.yml', /test-rollon/ }
#   end
# end