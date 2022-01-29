# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake test:annotate' do
  Given(:workbench) { 'test_annotate/lib' }
  Given(:base)      { 'lib/roro/stacks/unstoppable_developer_styles' }
  Given(:space)     { "#{base}/okonomi/languages/ruby/frameworks/rails" }
  Given(:file)      { "#{space}/versions/v6_1/test/0/_test.rb"}

  Given { quiet { run_task('test:annotate') } }

  Then { assert_file base }
  And  { assert_file space }
  And  { assert_file file, /describe ["']#\{adventure/ }


  # And  { assert_match /is valid/, output }
end