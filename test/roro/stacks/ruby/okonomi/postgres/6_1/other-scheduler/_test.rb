# frozen_string_literal: true

require 'test_helper'

describe '1 -> 2 -> 1: database: postgres, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
