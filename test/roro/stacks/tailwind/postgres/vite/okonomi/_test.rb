# frozen_string_literal: true

require 'stack_test_helper'

describe '6 tailwind -> 3 Postgres -> 4 Vite -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    debuggerer
  end

  focus
  Then { assert_correct_manifest(__dir__) }
end
