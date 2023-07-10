# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_postgres
  assert_stacked_postgres_mise
  assert_stacked_compose_service_db
  assert_stacked_postgres_service_db
  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  assert_file('mise/containers/app/Dockerfile', /postgresql-dev/)
end

def assert_stacked_postgres_mise
  assert_stacked_postgres_mise_base_env
  assert_stacked_postgres_mise_development_env
end

def assert_stacked_postgres_mise_base_env
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=postgresql/)
  assert_file(f, /db_pkg=postgresql-dev/)
  assert_file(f, /db_image=postgres/)
  assert_file(f, /db_image_version=14.1/)
  assert_file(f, %r{db_volume=/var/lib/postgresql/data})
end

def assert_stacked_postgres_mise_development_env
  f = 'mise/env/development.env'
  assert_file(f, /DATABASE_NAME=postgres/)
  assert_file(f, /DATABASE_NAME=postgres/)
  assert_file(f, /DATABASE_HOST=db/)
  assert_file(f, /DATABASE_PASSWORD=password/)
  assert_file(f, /POSTGRES_NAME=postgres/)
  assert_file(f, /POSTGRES_PASSWORD=password/)
  assert_file(f, /POSTGRES_USERNAME=postgres/)
end

def assert_stacked_postgres_service_db
  f = 'docker-compose.yml'
  # assert_yaml(f, :services, :app, :depends_on, 0, 'db')
  # assert_yaml(f, :services, :db, :image, 'postgres:14.1')
  # assert_yaml(f, :services, :db, :volumes, 0, %r{lib/postgresql/data})
end
# def assert_stacked_docker_db
# end
