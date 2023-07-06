# frozen_string_literal: true

require 'test_helper'

def assert_stacked_stacks
  assert_stacked_stacks_base_env
  assert_stacked_stacks_dockerfile
  assert_stacked_stacks_docker_compose
  assert_stacked_stacks_gemfile
  assert_file('entrypoints/docker-entrypoint.sh')
end

def assert_stacked_stacks_base_env
  f = 'mise/env/base.env'
  assert_file(f, /bundler_version=2.4.13/)
  assert_file(f, /docker_compose_version=3.9/)
  assert_file(f, /ruby_version=3.2.1/)
  assert_file(f, /RAILS_MAX_THREADS=5/)
  assert_file(f, %r{REDIS_URL=redis://redis:6379/0})
end

def assert_stacked_stacks_dockerfile
  f = 'Dockerfile'
  assert_file(f, /FROM ruby:3.2.1-alpine/)
  assert_file(f, /bundler:2.4.13/)
  assert_file(f, /nodejs/)
end

def assert_stacked_stacks_docker_compose
  f = 'docker-compose.yml'
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
  assert_yaml(f, :volumes, :db_data, nil)
  assert_yaml(f, :services, :app, :ports, 0, '3000:3000')
end

def assert_stacked_stacks_gemfile
  assert_file('Gemfile', /ruby ["']3.2.1["']/)
end

def assert_stacked_sqlite
  assert_stacked_stacks
  assert_file('config/database.yml', /adapter: sqlite3/)
  assert_file('Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/)
  assert_file('Dockerfile', /sqlite-dev/)
  refute_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  refute_content('mise/env/base.env', /db_volume/)
end
