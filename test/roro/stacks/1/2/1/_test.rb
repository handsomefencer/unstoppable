# frozen_string_literal: true

require 'test_helper'

describe '1 -> 2 -> 1: database: sqlite, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  describe 'entrypoints/docker-entrypoint.sh' do
    Then { assert_file 'entrypoints/docker-entrypoint.sh' }
  end

  describe 'config/database.yml' do
    Given(:file) { 'config/database.yml' }

    describe 'must be configured with sqlite3 adapter' do
      Then { assert_file file, /adapter: sqlite3/ }
    end
  end

  describe 'mise-en-place' do
    Then { assert_file 'mise/env/base.env' }
  end

  describe 'Gemfile with the correct' do
    describe 'rails version' do
      Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 7.0.5/ }
    end

    describe 'ruby version' do
      Then { assert_file 'Gemfile', /ruby ["']3.2.1["']/ }
    end

    describe 'db' do
      Then { assert_file 'Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/ }
    end
  end

  describe 'Dockerfile' do
    describe 'ruby version' do
      Then { assert_file 'Dockerfile', /FROM ruby:3.2.1-alpine/ }
    end

    describe 'bundler version' do
      Then { assert_file 'Dockerfile', /bundler:2.4.13/ }
    end
    describe 'packages' do
      describe 'sqlite-dev' do
        Then { assert_file 'Dockerfile', /sqlite-dev/ }
      end

      describe 'nodejs' do
        Then { assert_file 'Dockerfile', /nodejs/ }
      end
    end
  end

  describe 'docker-compose.yml' do
    Given(:file) { 'docker-compose.yml' }

    describe 'services' do
      describe 'app' do
        focus
        Then { assert_yaml(file, :services, :app, :ports, 0, '3000:3000') }
        And { refute_yaml(file, :services, :app, :depends_on, 0, 'db') }
      end
    end

    describe 'volumes' do
      Then { assert_file file, /\nvolumes:\n\s\sdb_data/ }
      And  { assert_file file, /\s\sgem_cache/ }
      And  { assert_file file, /\s\snode_modules/ }
    end
  end
end
