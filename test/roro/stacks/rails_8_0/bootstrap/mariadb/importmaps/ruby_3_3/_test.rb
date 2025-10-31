# frozen_string_literal: true

require 'stack_test_helper'

describe '3 rails_8_0 -> 1 Bootstrap -> 1 MariaDB -> 3 Importmaps -> 1 ruby_3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
