# frozen_string_literal: true

require 'test_helper'

describe '1 MariaDB -> 3 Vite -> 1 okonomi -> 1 Devise -> 1 Stripe -> 3 7_1 -> 2 importmap -> 1 3_1 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
