# frozen_string_literal: true

require 'stack_test_helper'

describe '1 rails_7_1 -> 5 skip_css -> 1 MariaDB -> 4 Vite -> 1 ruby_3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
