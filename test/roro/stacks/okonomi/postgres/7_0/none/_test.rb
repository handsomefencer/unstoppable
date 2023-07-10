# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 3 postgres -> 2 7_0 -> 1 none' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
  focus
  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_postgres
    assert_stacked_7_0
    refute_stacked_compose_service_redis
    refute_stacked_compose_service_sidekiq
  end
end
