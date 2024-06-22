# frozen_string_literal: true

require 'stack_test_helper'

describe '6 tailwind -> 2 MySQL -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
