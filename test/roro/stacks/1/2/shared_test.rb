# frozen_string_literal: true

require_relative '../shared_test'

def assert_1_2_tests
  assert_1_tests
  assert_correct_base_env

  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  assert_yaml('docker-compose.yml', :services, :db, :image, 'postgres:14.1')
  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  assert_file('Dockerfile', /postgresql-dev/)
end

def assert_correct_base_env
  assert_file('mise/env/base.env', /DATABASE_NAME/)
  assert_file('mise/env/base.env', /DATABASE_HOST/)
  assert_file('mise/env/base.env', /POSTGRES_PASSWORD/)
  assert_file('mise/env/base.env', /POSTGRES_USERNAME/)
end
