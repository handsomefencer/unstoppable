# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 1 mariadb -> 1 6_1 -> 1 none' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_mariadb
    assert_stacked_6_1
    assert_stacked_sidekiq
  end
end
