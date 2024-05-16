# frozen_string_literal: true

require 'test_helper'

describe '2 MySQL -> 2 Importmaps -> 1 okonomi -> 1 Devise -> 1 Stripe -> 3 7_1 -> 2 importmap -> 3 3_3 -> 2 other-scheduler' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
