# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 1 MariaDB -> 3 Importmaps -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
