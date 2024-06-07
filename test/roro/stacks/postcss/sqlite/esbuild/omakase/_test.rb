# frozen_string_literal: true

require 'stack_test_helper'

describe '3 PostCSS -> 4 SQLite -> 2 ESBuild -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
