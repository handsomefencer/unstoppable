# frozen_string_literal: true

require 'stack_test_helper'

describe '4 Sass -> 3 Postgres -> 1 Bun -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
