# frozen_string_literal: true

require 'test_helper'

describe '1 MariaDB -> 3 importmap -> 1 okonomi -> 1 Devise -> 2 other-payment -> 3 7_1 -> 2 importmap -> 3 3_3 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end