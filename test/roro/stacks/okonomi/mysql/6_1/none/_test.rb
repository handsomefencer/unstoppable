# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 2 -> 1: ' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_mysql
    assert_stacked_6_1
    refute_stacked_compose_service_redis
    refute_stacked_compose_service_sidekiq
  end
end
