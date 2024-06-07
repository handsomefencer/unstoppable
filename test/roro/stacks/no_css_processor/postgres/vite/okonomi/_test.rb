# frozen_string_literal: true

require 'stack_test_helper'

describe '5 no_css_processor -> 3 Postgres -> 4 Vite -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
