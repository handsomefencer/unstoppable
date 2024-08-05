# frozen_string_literal: true

require 'stack_test_helper'

describe '5 skip_css -> 2 MySQL -> 4 Vite -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    # skip
    debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
