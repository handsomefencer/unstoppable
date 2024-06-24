# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 1 MariaDB -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    #skip
    debuggerer
  end
#focus
  Then { assert_correct_manifest(__dir__) }
end
