# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 3 Postgres -> 4 Vite -> 2 omakase' do
  Given(:workbench) {}

  Given do
    skip
    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
