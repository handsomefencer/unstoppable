# frozen_string_literal: true

require 'test_helper'

describe '4 SQLite -> 2 Vite -> 1 okonomi -> 2 other-auth -> 3 7_1 -> 2 importmap -> 1 3_1 -> 2 other-scheduler' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end