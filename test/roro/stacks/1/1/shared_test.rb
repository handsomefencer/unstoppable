# frozen_string_literal: true

require_relative '../shared_test'

def assert_1_1_tests
  assert_1_tests
  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  assert_yaml('docker-compose.yml', :services, :db, :image, 'mysql:8.0.21')
  assert_yaml('docker-compose.yml', :services, :db, :volumes, 0, %r{lib/mysql})
  assert_file('config/database.yml', /adapter: mysql2/)
  assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  assert_file('Dockerfile', /mysql/)
end