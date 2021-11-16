# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare' do
  Given(:workspace) { '.circleci' }
  Given(:task)      { 'circleci:prepare' }
  Given(:run_task)  { Rake.application.invoke_task task }
  Given(:config)    { '.circleci/config.yml' }


  describe 'must create workflow from template' do
    Given { run_task }
    Then { assert_file '.circleci/config.yml', 'blah' }
  end
end