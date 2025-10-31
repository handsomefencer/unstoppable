# frozen_string_literal: true

require 'stack_test_helper'

describe '2 rails_7_2 -> 4 Sass -> 2 MySQL -> 3 Importmaps -> 1 ruby_3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
