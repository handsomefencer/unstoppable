# frozen_string_literal: true

require_relative '../shared_tests'

def assert_correct_configuration_mariadb
  assert_correct_configuration_okonomi
  assert_correct_mariadb_base_env
  assert_correct_mariadb_docker_compose
  assert_file('config/database.yml', /adapter: mysql2/)
  assert_file('Gemfile', /gem ["']mysql2["'], ["']~> 0.5/)
  assert_file('Dockerfile', /mysql-dev/)
end

def assert_correct_mariadb_base_env
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

def assert_correct_mariadb_docker_compose
  f = 'docker-compose.yml'
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
  assert_yaml(f, :services, :app, :ports, 0, '3000:3000')
  assert_yaml(f, :services, :db, :ports, 0, '3306:3306')
  assert_yaml(f, :services, :app, :depends_on, 0, 'db')
  assert_yaml(f, :services, :db, :image, 'mariadb')
  assert_yaml(f, :services, :db, :volumes, 0, %r{lib/mysql})
  assert_yaml(f, :services, :db, :volumes, 0, %r{lib/mysql})
end

def assert_correct_mariadb_base_env
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

# def assert_correct_okonomi_config_database
#   f = 'mise/env/base.env'
#   assert_file(f, /MYSQL_USER=root/)
#   assert_file(f, /MYSQL_HOST=db/)
#   assert_file(f, /MYSQL_PASSWORD/)
#   assert_file(f, /MYSQL_ROOT_PASSWORD/)
#   assert_file(f, /MYSQL_DATABASE/)
#   assert_file(f, /DATABASE_NAME/)
#   assert_file(f, /DATABASE_HOST/)
#   assert_file(f, /db_pkg=mariadb-dev/)
# end
