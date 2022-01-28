# frozen_string_literal: true

require 'test_helper'
require 'rake'

describe 'rake test:annotate' do
  Given(:workbench) { 'test_annotate/lib' }
  Given(:stacks)    { 'lib/roro/stacks/unstoppable_developer_styles/okonomi' }
  Given(:file)      { "#{stacks}/languages/"}
  Given { quiet { run_task('test:annotate') } }

  Then { assert_file 'lib/roro/stacks' }
  # And  { assert_match /is valid/, output }
end