# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 4 SQLite -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    skip
    debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
