# frozen_string_literal: true

require 'stack_test_helper'

describe '3 rails_8_0 -> 4 Sass -> 3 Postgres -> 1 Bun -> 1 ruby_3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
