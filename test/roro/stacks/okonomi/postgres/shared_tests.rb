# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_postgres
  assert_stacked_compose_service_db
  assert_stacked_compose_service_db_postgres
  assert_stacked_mise_base_env_postgres
  assert_stacked_mise_development_env_postgres
  assert_file('config/database.yml', /adapter: postgresql/)
  assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  assert_file('mise/containers/app/Dockerfile', /postgresql-dev/)
end

def assert_stacked_mise_base_env_postgres
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=postgresql/)
  assert_file(f, /db_pkg=postgresql-dev/)
  assert_file(f, /db_image=postgres/)
  assert_file(f, /db_image_version=14.1/)
  assert_file(f, %r{db_volume=/var/lib/postgresql/data})
end

def assert_stacked_mise_development_env_postgres
  f = 'mise/env/development.env'
  assert_file(f, /DATABASE_NAME=postgres/)
  assert_file(f, /DATABASE_NAME=postgres/)
  assert_file(f, /DATABASE_HOST=db/)
  assert_file(f, /DATABASE_PASSWORD=password/)
  assert_file(f, /POSTGRES_NAME=postgres/)
  assert_file(f, /POSTGRES_PASSWORD=password/)
  assert_file(f, /POSTGRES_USERNAME=postgres/)
end

def assert_stacked_compose_service_db_postgres
  a = ['docker-compose.yml', :services]
  assert_yaml(*a, :db, :image, 'postgres:14.1')
  assert_yaml(*a, :db, :volumes, 0, %r{db_data:/var/lib/postgresql/data})
end
