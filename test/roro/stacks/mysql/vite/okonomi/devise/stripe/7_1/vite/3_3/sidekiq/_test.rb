# frozen_string_literal: true

require 'test_helper'

describe '2 MySQL -> 3 Vite -> 1 okonomi -> 1 Devise -> 1 Stripe -> 3 7_1 -> 1 Vite -> 3 3_3 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
