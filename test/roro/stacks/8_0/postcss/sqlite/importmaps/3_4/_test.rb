# frozen_string_literal: true

require 'stack_test_helper'

describe '3 8_0 -> 3 PostCSS -> 4 SQLite -> 3 Importmaps -> 2 3_4' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
