# frozen_string_literal: true

require 'test_helper'

describe '3 Postgres -> 3 importmap -> 1 okonomi -> 1 Devise -> 2 other-payment -> 1 6_1 -> 2 3_2 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
