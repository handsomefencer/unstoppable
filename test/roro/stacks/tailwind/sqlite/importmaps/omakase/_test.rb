# frozen_string_literal: true

require 'test_helper'

describe '5 tailwind -> 4 SQLite -> 3 Importmaps -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
