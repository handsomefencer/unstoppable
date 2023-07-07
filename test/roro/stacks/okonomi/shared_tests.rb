# frozen_string_literal: true

require_relative '../shared_tests'

def assert_stacked_okonomi
  # assert_stacked_redis
  # assert_stacked_sidekiq
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
