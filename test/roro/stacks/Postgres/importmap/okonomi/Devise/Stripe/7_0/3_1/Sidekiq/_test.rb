# frozen_string_literal: true

require 'test_helper'

describe '3 Postgres -> 3 importmap -> 1 okonomi -> 1 Devise -> 1 Stripe -> 2 7_0 -> 1 3_1 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
