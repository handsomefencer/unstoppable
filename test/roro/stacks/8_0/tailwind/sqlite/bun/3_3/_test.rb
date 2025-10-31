# frozen_string_literal: true

require 'stack_test_helper'

describe '3 8_0 -> 6 tailwind -> 4 SQLite -> 1 Bun -> 1 3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
