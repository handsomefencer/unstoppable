# frozen_string_literal: true

require 'stack_test_helper'

describe '6 tailwind -> 1 MariaDB -> 1 Bun -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    # skip
    debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
