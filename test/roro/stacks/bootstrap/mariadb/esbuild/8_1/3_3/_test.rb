# frozen_string_literal: true

require 'stack_test_helper'

describe '1 Bootstrap -> 1 MariaDB -> 2 ESBuild -> 4 8_1 -> 1 3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
