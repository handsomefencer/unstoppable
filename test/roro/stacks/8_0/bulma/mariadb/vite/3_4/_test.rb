# frozen_string_literal: true

require 'stack_test_helper'

describe '3 8_0 -> 2 Bulma -> 1 MariaDB -> 4 Vite -> 2 3_4' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
