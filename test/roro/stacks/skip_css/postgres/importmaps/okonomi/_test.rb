# frozen_string_literal: true

require 'stack_test_helper'

describe '5 skip_css -> 3 Postgres -> 3 Importmaps -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    #skip
    debuggerer
  end
#focus
  Then { assert_correct_manifest(__dir__) }
end
