# frozen_string_literal: true

require 'stack_test_helper'

describe '2 7_2 -> 4 Sass -> 3 Postgres -> 2 ESBuild -> 1 3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
