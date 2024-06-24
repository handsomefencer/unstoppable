# frozen_string_literal: true

require 'stack_test_helper'

describe '3 PostCSS -> 2 MySQL -> 1 Bun -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    skip
    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
