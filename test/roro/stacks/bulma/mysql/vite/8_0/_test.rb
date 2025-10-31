# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 2 MySQL -> 4 Vite -> 3 8_0' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
