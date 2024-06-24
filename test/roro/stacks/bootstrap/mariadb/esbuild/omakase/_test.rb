# frozen_string_literal: true

require 'stack_test_helper'

describe '1 Bootstrap -> 1 MariaDB -> 2 ESBuild -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    skip
    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
