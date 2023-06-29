# frozen_string_literal: true

require 'test_helper'

def assert_1_tests
  assert_correct_env
  assert_correct_docker_compose
  assert_correct_dockerfile
  assert_file('entrypoints/docker-entrypoint.sh')
  assert_file('mise/env/base.env', /db_vendor/)
  assert_file('Gemfile', /ruby ["']3.2.1["']/)
end

def assert_correct_docker_compose
  assert_file('docker-compose.yml', /\nvolumes:\n\s\sdb_data/)
  assert_file('docker-compose.yml', /\s\sgem_cache/)
  assert_file('docker-compose.yml', /\s\snode_modules/)
  assert_yaml('docker-compose.yml', :services, :app, :ports, 0, '3000:3000')
  assert_yaml('docker-compose.yml', :services, :app, :ports, 0, '3000:3000')
end

def assert_correct_dockerfile
  assert_file('Dockerfile', /FROM ruby:3.2.1-alpine/)
  assert_file('Dockerfile', /bundler:2.4.13/)
  assert_file('Dockerfile', /nodejs/)
end

def assert_correct_env
  assert_file('mise/env/base.env', /RAILS_MAX_THREADS/)
end
