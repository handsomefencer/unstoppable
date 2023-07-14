# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_mariadb
  assert_stacked_compose_service_db
  assert_stacked_compose_service_db_mariadb
  assert_stacked_mise_base_env_mariadb
  assert_stacked_mise_development_env_mariadb
end

def assert_stacked_compose_service_db_mariadb
  a = ['docker-compose.yml', :services]
  assert_yaml(*a, :db, :image, 'mariadb:11.0')
end

def assert_stacked_mise_base_env_mariadb
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=mysql/)
  assert_file(f, /db_image=mariadb/)
  assert_file(f, %r{db_volume=/var/lib/mariadb})
  assert_file(f, /DATABASE_HOST=db/)
  assert_file(f, /DATABASE_NAME=development/)
  assert_file(f, /MYSQL_DATABASE=development/)
  assert_file(f, /MYSQL_HOST=db/)
  assert_file(f, /MYSQL_USER=root/)
  assert_file(f, /MYSQL_PASSWORD=root/)
  assert_file(f, /MYSQL_ROOT_PASSWORD=root/)
end

def assert_stacked_mise_development_env_mariadb
  f = 'mise/env/development.env'
  assert_file(f, /db_pkg=mariadb-dev/)
end
