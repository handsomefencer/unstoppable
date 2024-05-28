# frozen_string_literal: true

require 'stack_test_helper'

describe '5 none -> 2 MySQL -> 4 Vite -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
