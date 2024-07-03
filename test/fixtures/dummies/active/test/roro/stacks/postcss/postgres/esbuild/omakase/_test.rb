# frozen_string_literal: true

require 'stack_test_helper'

describe '3 PostCSS -> 3 Postgres -> 2 ESBuild -> 2 omakase' do
  Given(:workbench) {}

  Given do

    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
