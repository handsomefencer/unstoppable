# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 2 -> 1: ' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
