# frozen_string_literal: true

require 'stack_test_helper'

describe '4 Sass -> 3 Postgres -> 3 Importmaps -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    #skip
    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
