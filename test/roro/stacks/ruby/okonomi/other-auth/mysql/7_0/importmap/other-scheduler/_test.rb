# frozen_string_literal: true

require 'test_helper'

describe '2 ruby -> 1 okonomi -> 2 other-auth -> 2 mysql -> 2 7_0 -> 1 importmap -> 1 other-scheduler' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  focus
  Then { assert_correct_manifest(__dir__) }
end
