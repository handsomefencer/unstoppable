# frozen_string_literal: true

require 'test_helper'

describe '1 Bootstrap -> 4 SQLite -> 3 Importmaps -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
focus
  Then { assert_correct_manifest(__dir__) }
end
