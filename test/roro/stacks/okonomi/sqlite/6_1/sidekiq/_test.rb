# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 4 sqlite -> 1 6_1 -> 2 sidekiq' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_sqlite
    assert_stacked_6_1
    assert_stacked_compose_service_redis
    assert_stacked_compose_service_sidekiq
  end
end
