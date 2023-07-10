# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_postgres
  assert_stacked_postgres_env
  assert_stacked_postgres_docker_compose
  assert_stacked_stacks_env_files
  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  # assert_file('Dockerfile', /postgresql-dev/)
end

def assert_stacked_postgres_env
  f = 'mise/env/development.env'
  assert_file(f, /DATABASE_NAME/)
  assert_file(f, /DATABASE_HOST/)
  assert_file(f, /DATABASE_PASSWORD/)
  assert_file(f, /POSTGRES_NAME/)
  assert_file(f, /POSTGRES_PASSWORD/)
  assert_file(f, /POSTGRES_USERNAME/)
end

def assert_stacked_postgres_docker_compose
  f = 'docker-compose.yml'
  assert_yaml(f, :services, :app, :depends_on, 0, 'db')
  assert_yaml(f, :services, :db, :image, 'postgres:14.1')
  assert_yaml(f, :services, :db, :volumes, 0, %r{lib/postgresql/data})
end
