# frozen_string_literal: true

require 'test_helper'

describe '6 tailwind -> 4 SQLite -> 3 Importmaps -> 1 okonomi' do
  Given(:workbench) {}

  # Given(:story) { Rollon.new(__dir__) }
  Given do
    debuggerer
    # story.rollon
    # Rollon.new(__dir__)
    # rollon(__dir__)
  end
  focus
  Then { assert_correct_manifest(__dir__) }
  # And { assert_file 'config/tailwind.config.js' }
end
