# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 2 MySQL -> 4 Vite -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
