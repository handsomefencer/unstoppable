# frozen_string_literal: true

require 'stack_test_helper'

describe '3 PostCSS -> 4 SQLite -> 1 Bun -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    skip
    debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
