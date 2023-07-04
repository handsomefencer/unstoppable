# frozen_string_literal: true

require_relative '../shared_tests'

def assert_correct_configuration_mysql
  assert_configuration_okonomi
  assert_correct_okonomi_mysql_base_env
  assert_correct_okonomi_mysql_docker_compose
  assert_file('config/database.yml', /adapter: mysql2/)
  assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  assert_file('Dockerfile', /mysql-dev/)

  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  assert_yaml('docker-compose.yml', :services, :db, :image, 'mysql:8.0.21')
  assert_yaml('docker-compose.yml', :services, :db, :volumes, 0, %r{lib/mysql})
  assert_file('config/database.yml', /adapter: mysql2/)
  assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  assert_file('Dockerfile', /mysql-dev/)
end

def assert_correct_okonomi_mysql_base_env
  assert_file('Dockerfile', /mysql-dev/)
end

def assert_correct_okonomi_mysql_docker_compose
  assert_file('Dockerfile', /mysql-dev/)
end

def assert_correct_base_env
  f = 'mise/env/base.env'
  assert_file(f, /MYSQL_USER/)
  assert_file(f, /MYSQL_HOST/)
  assert_file(f, /MYSQL_PASSWORD/)
  assert_file(f, /MYSQL_ROOT_PASSWORD/)
  assert_file(f, /MYSQL_DATABASE/)
  assert_file(f, /DATABASE_NAME/)
  assert_file(f, /DATABASE_HOST/)
  assert_file(f, /db_pkg=mariadb-dev/)
end

def assert_correct_config_database
  assert_file('mise/env/base.env', /MYSQL_USER=root/)
  assert_file('mise/env/base.env', /MYSQL_HOST=db/)
  assert_file('mise/env/base.env', /MYSQL_PASSWORD/)
  assert_file('mise/env/base.env', /MYSQL_ROOT_PASSWORD/)
  assert_file('mise/env/base.env', /MYSQL_DATABASE/)
  assert_file('mise/env/base.env', /DATABASE_NAME/)
  assert_file('mise/env/base.env', /DATABASE_HOST/)
  assert_file('mise/env/base.env', /db_pkg=mariadb-dev/)
end
