# frozen_string_literal: true

require 'test_helper'

def assert_configuration_okonomi
  assert_correct_okonomi_base_env
  assert_correct_okonomi_dockerfile
  assert_correct_okonomi_docker_compose
  assert_correct_okonomi_gemfile
  assert_file('entrypoints/docker-entrypoint.sh')
end

def assert_correct_okonomi_base_env
  assert_file('mise/env/base.env', /RAILS_MAX_THREADS/)
end

def assert_correct_okonomi_dockerfile
  f = 'Dockerfile'
  assert_file(f, /FROM ruby:3.2.1-alpine/)
  assert_file(f, /bundler:2.4.13/)
  assert_file(f, /nodejs/)
end

def assert_correct_okonomi_docker_compose
  f = 'docker-compose.yml'
  assert_file(f, /\nvolumes:\n\s\sdb_data/)
  assert_file(f, /\s\sgem_cache/)
  assert_file(f, /\s\snode_modules/)
  assert_yaml(f, :services, :app, :ports, 0, '3000:3000')
end

def assert_correct_okonomi_gemfile
  assert_file('Gemfile', /ruby ["']3.2.1["']/)
end
