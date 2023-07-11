# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_okonomi; end

def assert_stacked_6_1
  assert_file('Gemfile', /gem ["']rails["'], ["']~> 6.1.7/)
  assert_file('mise/env/base.env', /rails_version=6.1.7/)
end

def assert_stacked_compose_service_sidekiq
  f = 'mise/containers/app/env/base.env'
  assert_file(f, %r{REDIS_URL=redis://redis:6379/0})
  f = 'docker-compose.yml'
  assert_yaml(f, :services, :sidekiq, :image, 'unstoppable')
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
  assert_file(f, /\s\sredis/)
end

def refute_stacked_compose_service_sidekiq
  f = 'mise/containers/app/env/base.env'
  refute_content(f, %r{REDIS_URL=redis://redis:6379/0})
  f = 'docker-compose.yml'
  refute_yaml(f, :services, :sidekiq, :image, 'unstoppable')
end

def assert_stacked_compose_service_redis
  a = ['docker-compose.yml', :services, :redis]
  assert_yaml(*a, :image, /redis:7.0-alpine/)
  assert_yaml(*a, :command, 'redis-server')
  assert_yaml(*a, :ports, 0, '6379:6379')
  assert_yaml(*a, :volumes, 0, 'redis:/data')
end

def refute_stacked_compose_service_redis
  f = 'docker-compose.yml'
  a = ['docker-compose.yml', :services, :redis]
  assert_yaml(f, :services, :app, :depends_on, 1, nil)
  refute_content(f, /redis:/)
end
