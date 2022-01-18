# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:prepare:config:pack' do
  Given(:workbench) { '.circleci' }
  Given { run_task('ci:prepare:config:pack') }
  Then { assert_match /Packing/, @output.first }
  And  { assert_match /Packed/, @output.first }
  And  { assert_file '.circleci/config.yml' }
end