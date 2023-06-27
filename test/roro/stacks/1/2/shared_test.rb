# frozen_string_literal: true

require_relative '../shared_test'

def assert_1_2_tests
  assert_1_tests
  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  assert_yaml('docker-compose.yml', :services, :db, :image, 'postgres:14.1')
  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  assert_file('Dockerfile', /postgresql-dev/)
end
