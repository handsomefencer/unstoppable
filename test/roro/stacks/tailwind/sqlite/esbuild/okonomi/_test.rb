# frozen_string_literal: true

require 'test_helper'

describe '5 tailwind -> 4 SQLite -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
focus
  Then { assert_correct_manifest(__dir__) }
end
