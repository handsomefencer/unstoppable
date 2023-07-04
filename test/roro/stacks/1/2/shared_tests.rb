# frozen_string_literal: true

require_relative '../shared_tests'

def assert_correct_configuration_mysql
  assert_correct_configuration_okonomi
  assert_correct_mysql_base_env
  assert_correct_mysql_docker_compose
  assert_file('Dockerfile', /mysql-dev/)
  assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  assert_file('config/database.yml', /adapter: mysql2/)
end

def assert_correct_mysql_base_env
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

def assert_correct_mysql_docker_compose
  assert_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  assert_yaml('docker-compose.yml', :services, :db, :image, 'mysql:8.0.21')
  assert_yaml('docker-compose.yml', :services, :db, :volumes, 0, %r{lib/mysql})
end
