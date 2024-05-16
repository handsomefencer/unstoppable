# frozen_string_literal: true

require 'test_helper'

describe '4 SQLite -> 3 Vite -> 1 okonomi -> 1 Devise -> 2 other-payment -> 3 7_1 -> 1 Vite -> 2 3_2 -> 2 other-scheduler' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
