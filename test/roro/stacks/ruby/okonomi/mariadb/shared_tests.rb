# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_mariadb
  assert_stacked_compose_service_db
  # assert_stacked_compose_service_db_mariadb
  # assert_stacked_mise_base_env_mariadb
  # assert_stacked_mise_development_env_mariadb
end
