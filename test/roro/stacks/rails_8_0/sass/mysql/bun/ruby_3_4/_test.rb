# frozen_string_literal: true

require 'stack_test_helper'

describe '3 rails_8_0 -> 4 Sass -> 2 MySQL -> 1 Bun -> 2 ruby_3_4' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
