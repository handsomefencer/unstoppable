# frozen_string_literal: true

require 'test_helper'

def assert_stacked_stacks
  assert_stacked_mise
  assert_stacked_rails
  assert_stacked_stacks_dockerfile
  assert_stacked_stacks_docker_compose
  assert_stacked_stacks_gemfile
  assert_file('entrypoints/docker-entrypoint.sh')
end

def assert_stacked_mise
  assert_file('mise/env/base.env')
  assert_file('mise/env/development.env')
  assert_file('mise/env/production.env')
  assert_file('mise/containers/db/env/base.env')
  assert_file('mise/containers/db/env/development.env')
  assert_file('mise/containers/db/env/development.env')
end

def assert_stacked_rails
  assert_file('mise/env/base.env', /rails_version/)
  assert_file('mise/containers/app/env/base.env', /RAILS_MAX_THREADS/)
  assert_file('mise/containers/app/env/base.env', /REDIS_URL/)
end

def assert_stacked_6_1
  assert_file('Gemfile', /gem ["']rails["'], ["']~> 6.1.7/)
end

def assert_stacked_7_0
  assert_file('Gemfile', /gem ["']rails["'], ["']~> 7.0.6/)
end

def refute_stacked_sidekiq
  f = 'mise/env/base.env'
  refute_content('mise/env/base.env', %r{REDIS_URL=redis://redis:6379/0})

  f = 'docker-compose.yml'
  refute_content('docker-compose.yml', /\s\sredis/)
  refute_yaml('docker-compose.yml', :services, :redis, :image, /redis/)
end

def assert_stacked_stacks_base_env
  f = 'mise/env/base.env'
  assert_file(f, /bundler_version=2.4.13/)
  assert_file(f, /docker_compose_version=3.9/)
  assert_file(f, /ruby_version=3.2.1/)
end

def assert_stacked_stacks_development_env
  f = 'mise/env/base.env'
  assert_file(f, /bundler_version=2.4.13/)
  assert_file(f, /docker_compose_version=3.9/)
  assert_file(f, /ruby_version=3.2.1/)
end

def assert_stacked_stacks_dockerfile
  # f = 'Dockerfile'
  # assert_file(f, /FROM ruby:3.2.1-alpine/)
  # assert_file(f, /bundler:2.4.13/)
  # assert_file(f, /nodejs/)
end

def assert_stacked_stacks_docker_compose
  f = 'docker-compose.yml'
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
  assert_yaml(f, :volumes, :db_data, nil)
  assert_yaml(f, :services, :app, :ports, 0, '3000:3000')
end

def assert_stacked_stacks_env_files
  f = 'docker-compose.yml'
  assert_yaml(f, :services, :app, :env_file, 0, %r{./mise/env/base.env})
  assert_yaml(f, :services, :app, :env_file, 1, %r{./mise/env/development.env})
  assert_yaml(f, :services, :app, :env_file, 2, %r{./mise/containers/app/env/base.env})
  assert_yaml(f, :services, :app, :env_file, 3, %r{./mise/containers/app/env/development.env})
  # assert_yaml(f, :services, :db, :env_file, 0, %r{./mise/env/base.env})
  assert_yaml(f, :services, :db, :env_file, 1, %r{./mise/env/development.env})
  # assert_yaml(f, :services, :db, :env_file, 2, %r{./mise/containers/db/env/base.env})
  # assert_yaml(f, :services, :db, :env_file, 3, %r{./mise/containers/db/env/development.env})
end

def assert_stacked_stacks_gemfile
  assert_file('Gemfile', /ruby ["']3.2.1["']/)
end

def assert_stacked_sqlite
  assert_file('config/database.yml', /adapter: sqlite3/)
  assert_file('Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/)
  # assert_file('Dockerfile', /sqlite-dev/)
  refute_yaml('docker-compose.yml', :services, :app, :depends_on, 0, 'db')
  refute_content('mise/env/base.env', /db_volume/)
end

def assert_stacked_sidekiq
  f = 'docker-compose.yml'
  assert_yaml(f, :services, :sidekiq, :image, 'unstoppable')
end

def assert_stacked_redis
  f = 'mise/env/base.env'
  assert_file(f, %r{REDIS_URL=redis://redis:6379/0})
  assert_yaml('docker-compose.yml')

  f = 'docker-compose.yml'
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
  assert_file(f, /\s\sredis/)
  assert_yaml(f, :services, :redis, :image, 'redis:7.0-alpine')
end
