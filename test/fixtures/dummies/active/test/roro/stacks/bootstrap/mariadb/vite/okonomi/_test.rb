# frozen_string_literal: true

require 'stack_test_helper'

describe '1 Bootstrap -> 1 MariaDB -> 4 Vite -> 1 okonomi' do
  Given(:workbench) {}

  Given do

    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end