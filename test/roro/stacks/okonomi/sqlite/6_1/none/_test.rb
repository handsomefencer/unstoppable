# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 3 postgres -> 2 7_0 -> 2 sidekiq' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_sqlite
    assert_stacked_6_1
    refute_stacked_sidekiq
  end
end
