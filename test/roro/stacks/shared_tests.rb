# frozen_string_literal: true

require 'test_helper'

def assert_stacked_stacks
  assert_stacked_mise
  assert_stacked_rails
  assert_stacked_ruby
  assert_stacked_docker_volumes
  assert_stacked_docker_anchor_app
  assert_stacked_docker_app
  # assert_stacked_docker_db
  assert_file('entrypoints/docker-entrypoint.sh')
end

def assert_stacked_mise
  f = 'mise/env/base.env'
  assert_file(f, /app_name=unstoppable/)
  assert_file(f, /docker_compose_version=3.9/)
  assert_file('mise/env/development.env')
  assert_file('mise/env/production.env')
  assert_file('mise/containers/db/env/base.env')
  assert_file('mise/containers/db/env/development.env')
  assert_file('mise/containers/db/env/development.env')
end

def assert_stacked_rails
  assert_file('mise/containers/app/env/base.env', /RAILS_MAX_THREADS/)
end

def assert_stacked_ruby
  f = 'mise/env/base.env'
  assert_file(f, /ruby_version=3.2.1/)
  assert_file(f, /bundler_version=2.4.13/)
  assert_file('Gemfile', /ruby ["']3.2.1["']/)
  f = 'mise/containers/app/Dockerfile'
  assert_file(f, /FROM ruby:3.2.1-alpine/)
  assert_file(f, /bundler:2.4.13/)
end

def assert_stacked_docker_volumes
  f = 'docker-compose.yml'
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
end

def assert_stacked_docker_anchor_app
  f = 'docker-compose.yml'
  a = [f, :"x-app"]
  assert_yaml(*a, :depends_on, 0, 'db')
  assert_yaml(*a, :env_file, 0, './mise/env/base.env')
  assert_yaml(*a, :env_file, 1, %r{mise/env/development.env})
  assert_yaml(*a, :env_file, 2, %r{containers/app/env/base.env})
  assert_yaml(*a, :env_file, 3, %r{containers/app/env/development.env})
  assert_yaml(*a, :image, 'unstoppable')
  assert_yaml(*a, :user, 'root')
  assert_yaml(*a, :volumes, 0, %r{\$PWD:/app})
end

def assert_stacked_docker_app
  f = 'docker-compose.yml'
  a = [f, :services, :app]
  assert_yaml(*a, :ports, 0, '3000:3000')
  assert_yaml(*a, :build, :context, '.')
  assert_yaml(*a, :build, :dockerfile, %r{/mise/containers/app/Dockerfile})
end

def assert_stacked_docker_db
  f = 'docker-compose.yml'
  a = [f, :services, :db]
  assert_yaml(*a, :ports, 0, '3000:3000')
  assert_yaml(*a, :build, :context, '.')
  assert_yaml(*a, :build, :dockerfile, %r{/mise/containers/app/Dockerfile})
end

def assert_stacked_6_1
  assert_file('Gemfile', /gem ["']rails["'], ["']~> 6.1.7/)
  assert_file('mise/env/base.env', /rails_version=6_1/)
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

def assert_stacked_gemfile
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
  assert_file('mise/containers/app/env/base.env', /REDIS_URL/)
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
