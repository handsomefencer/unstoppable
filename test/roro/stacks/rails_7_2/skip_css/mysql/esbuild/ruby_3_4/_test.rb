# frozen_string_literal: true

require 'stack_test_helper'

describe '2 rails_7_2 -> 5 skip_css -> 2 MySQL -> 2 ESBuild -> 2 ruby_3_4' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
