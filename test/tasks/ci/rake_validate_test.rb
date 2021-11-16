# # frozen_string_literal: true
#
# require 'test_helper'
# require 'rake'
#
# describe 'rake ci:config:validate' do
#   Given!(:workbench) { '.circleci' }
#   Given(:tasks)     { %w[ ci:config:pack ci:config:validate ] }
#   Given(:run_task)  { tasks.each { |t| Rake.application.invoke_task t } }
#   Given(:output)    { capture_subprocess_io { run_task } }
#   Given { output }
#
#   Then { assert_match 'is valid', output.first }
#   # Then { assert_match 'is valid', output }
# end