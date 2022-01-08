# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:config:pack' do
  Given(:workbench) { '.circleci' }
  Given(:output) { run_task('ci:config:pack') }
  Given { skip }
  Then { assert_match /Packing/, output }
  And  { assert_match /Packed/, output }
  And  { assert_file '.circleci/config.yml' }
end