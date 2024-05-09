# frozen_string_literal: true

require 'test_helper'

describe '3 Postgres -> 3 importmap -> 2 omakase' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
  focus
  Then { assert_correct_manifest(__dir__) }
end
