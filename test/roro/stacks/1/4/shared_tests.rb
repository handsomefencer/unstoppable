# frozen_string_literal: true

require_relative '../shared_tests'

def assert_correct_configuration_sqlite
  assert_correct_configuration_okonomi
  assert_file('config/database.yml', /adapter: sqlite3/)
  assert_file('Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/)
  assert_file('Dockerfile', /sqlite-dev/)
  refute_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
end
