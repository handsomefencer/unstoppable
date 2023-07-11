# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_mysql
  assert_stacked_compose_service_db
  assert_stacked_compose_service_db_mysql
  assert_stacked_mise_base_env_mysql
  assert_stacked_mise_development_env_mysql
  assert_file('config/database.yml', /adapter: mysql/)
  assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  assert_file('mise/containers/app/Dockerfile', /mysql-dev/)
end

def assert_stacked_mise_base_env_mysql
  f = 'mise/env/base.env'
  assert_file(f, /db_vendor=mysql/)
  assert_file(f, /db_pkg=mysql-dev/)
  assert_file(f, /db_image=mysql/)
  assert_file(f, /db_image_version=8.0.21/)
  assert_file(f, %r{db_volume=/var/lib/mysql})
end

def assert_stacked_mise_development_env_mysql
  f = 'mise/env/development.env'
  assert_file(f, /DATABASE_HOST=db/)
  assert_file(f, /DATABASE_NAME=development/)
  assert_file(f, /MYSQL_DATABASE=development/)
  assert_file(f, /MYSQL_HOST=db/)
  assert_file(f, /MYSQL_USER=root/)
  assert_file(f, /MYSQL_PASSWORD=root/)
  assert_file(f, /MYSQL_ROOT_PASSWORD=root/)
end

def assert_stacked_compose_service_db_mysql
  a = ['docker-compose.yml', :services]
  assert_yaml(*a, :db, :image, 'mysql:8.0.21')
  assert_yaml(*a, :db, :volumes, 0, %r{db_data:/var/lib/mysql})
end
