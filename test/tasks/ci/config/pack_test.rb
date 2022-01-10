# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake ci:config:pack' do
  Given(:workbench) { '.circleci' }
  Given(:output) { capture_subprocess_io { Rake::Task['ci:config:pack'].execute } }
  Then { assert_match /Packing/, output.first }
  And  { assert_match /Packed/, output.first }
  And  { assert_file '.circleci/config.yml' }
end