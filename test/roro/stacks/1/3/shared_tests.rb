# frozen_string_literal: true

require_relative '../shared_tests'

def assert_correct_configuration_postgres
  assert_correct_configuration_okonomi
  assert_correct_postgres_base_env
  assert_correct_postgres_docker_compose

  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  assert_file('Dockerfile', /postgresql-dev/)
end

def assert_correct_postgres_base_env
  f = 'mise/env/base.env'
  assert_file(f, /DATABASE_NAME/)
  assert_file(f, /DATABASE_HOST/)
  assert_file(f, /DATABASE_PASSWORD/)
  assert_file(f, /POSTGRES_PASSWORD/)
  assert_file(f, /POSTGRES_USERNAME/)
end

def assert_correct_postgres_docker_compose
  f = 'docker-compose.yml'
  assert_yaml(f, :services, :app, :depends_on, 0, 'db')
  assert_yaml(f, :services, :db, :image, 'postgres:14.1')
  assert_yaml(f, :services, :db, :volumes, 0, %r{lib/postgresql/data})
end
