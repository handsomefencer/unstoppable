# frozen_string_literal: true

require 'test_helper'

describe '1 MariaDB -> 2 Vite -> 1 okonomi -> 1 Devise -> 1 Stripe -> 1 6_1 -> 1 3_1 -> 2 other-scheduler' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
