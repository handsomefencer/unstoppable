# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 1 -> 2: database: mariadb, rails version: 7.0' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end
  focus
  Then do
    assert_stacked_7_0
    assert_stacked_stacks
    # assert_stacked_okonomi
    # assert_stacked_mariadb
    # assert_stacked_compose_service_redis
    # assert_stacked_compose_service_sidekiq
    # assert_stacked_compose_app_depends_on
    # assert_stacked_compose_service_vite
  end
end
