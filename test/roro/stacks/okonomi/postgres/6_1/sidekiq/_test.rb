# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 2 -> 1: database: postgres, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_postgres
    assert_stacked_6_1
    assert_stacked_sidekiq
  end
end