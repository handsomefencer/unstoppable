# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 4 sqlite -> 2 7_0 -> 1 none' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
  focus
  Then { assert_correct_manifest(__dir__) }
end
