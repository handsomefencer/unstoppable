# frozen_string_literal: true

require 'test_helper'

describe '1 -> 1 -> 2: database: mariadb, rails version: 7.0' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
