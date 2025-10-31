# frozen_string_literal: true

require 'stack_test_helper'

describe '3 8_0 -> 3 PostCSS -> 1 MariaDB -> 3 Importmaps -> 1 3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
