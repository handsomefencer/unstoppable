# frozen_string_literal: true

require 'test_helper'

describe '6 tailwind -> 4 SQLite -> 3 Importmaps -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
  And { assert_file 'config/tailwind.config.js' }
end
