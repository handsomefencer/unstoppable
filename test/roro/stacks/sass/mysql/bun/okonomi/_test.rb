# frozen_string_literal: true

require 'stack_test_helper'

describe '4 Sass -> 2 MySQL -> 1 Bun -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
