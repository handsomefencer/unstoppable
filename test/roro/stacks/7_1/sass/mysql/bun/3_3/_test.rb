# frozen_string_literal: true

require 'stack_test_helper'

describe '1 7_1 -> 4 Sass -> 2 MySQL -> 1 Bun -> 1 3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
