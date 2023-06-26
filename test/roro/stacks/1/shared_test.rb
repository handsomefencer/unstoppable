require 'test_helper'

def assert_1_tests
  assert_file('entrypoints/docker-entrypoint.sh')
  assert_file('mise/env/base.env')
  assert_file('Gemfile', /ruby ["']3.2.1["']/)
  assert_file('Dockerfile', /FROM ruby:3.2.1-alpine/)
  assert_file('Dockerfile', /bundler:2.4.13/)
  assert_file('Dockerfile', /nodejs/)
  assert_yaml('docker-compose.yml', :services, :app, :ports, 0, '3000:3000')
  assert_file('docker-compose.yml', /\nvolumes:\n\s\sdb_data/)
  assert_file('docker-compose.yml', /\s\sgem_cache/)
  assert_file('docker-compose.yml', /\s\snode_modules/)
end
