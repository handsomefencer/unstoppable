# frozen_string_literal: true

require 'stack_test_helper'

describe '5 no_css_processor -> 4 SQLite -> 2 ESBuild -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
