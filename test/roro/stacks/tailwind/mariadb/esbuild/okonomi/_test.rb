# frozen_string_literal: true

require 'stack_test_helper'

describe '6 tailwind -> 1 MariaDB -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    skip
    debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
