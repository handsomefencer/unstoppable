# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:config:validate' do
  Given(:workbench) { '.circleci' }
  Given(:output) { capture_subprocess_io { run_task('ci:config:validate') }.first }

  Given { quiet { run_task('ci:config:pack') } }

  Then { assert_match /Validating/, output }
  And  { assert_match /is valid/, output }
end