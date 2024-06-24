# frozen_string_literal: true

require 'stack_test_helper'

describe '3 PostCSS -> 3 Postgres -> 3 Importmaps -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    #skip
    debuggerer
  end
#focus
  Then { assert_correct_manifest(__dir__) }
end
