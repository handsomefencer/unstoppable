# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_mariadb
  assert_stacked_compose_service_db
  assert_stacked_compose_service_db_mariadb
  assert_stacked_mise_base_env_mariadb
  assert_stacked_mise_development_env_mariadb
  # assert_stacked_mise_development_env_postgres
  # assert_file('config/database.yml', /adapter: postgresql/)
  # assert_file('Gemfile', /gem ["']pg["'], ["']~> 1.1/)
  # assert_file('mise/containers/app/Dockerfile', /postgresql-dev/)
end

def assert_stacked_compose_service_db_mariadb
  a = ['docker-compose.yml', :services]
  assert_yaml(*a, :db, :image, 'mariadb:11.2')
  # assert_yaml(*a, :db, :volumes, 0, %r{db_data:/var/lib/postgresql/data})
end

def assert_stacked_mise_base_env_mariadb
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=mysql/)
  assert_file(f, /db_pkg=mariadb-dev/)
  assert_file(f, /db_image=mariadb/)
  assert_file(f, /db_image_version=11.2/)
  assert_file(f, %r{db_volume=/var/lib/mariadb})
end

def assert_stacked_mise_development_env_mariadb
  f = 'mise/env/development.env'
  assert_file(f, /DATABASE_HOST=db/)
  assert_file(f, /DATABASE_NAME=development/)
  assert_file(f, /MYSQL_DATABASE=development/)
  assert_file(f, /MYSQL_HOST=db/)
  assert_file(f, /MYSQL_USER=root/)
  assert_file(f, /MYSQL_PASSWORD=root/)
  assert_file(f, /MYSQL_ROOT_PASSWORD=root/)
end
