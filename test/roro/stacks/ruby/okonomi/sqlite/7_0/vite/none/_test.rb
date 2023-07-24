# frozen_string_literal: true

require 'test_helper'

describe '1 okonomi -> 4 sqlite -> 2 7_0 -> 2 vite -> 1 none' do
  Given(:workbench) {}

  Given do
    skip
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
