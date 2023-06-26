# frozen_string_literal: true

require 'test_helper'

describe '1 -> 1 -> 1: database: postgres, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    @rollon_dummies = true
    rollon(__dir__)
  end

  describe 'entrypoints/docker-entrypoint.sh' do
    Then { assert_file 'entrypoints/docker-entrypoint.sh' }
  end

  describe 'config/database.yml' do
    Given(:file) { 'config/database.yml' }

    describe 'with postgres' do
      Then { assert_file file, /adapter: postgresql/ }
    end
  end

  describe 'mise-en-place' do
    Then { assert_file 'mise/env/base.env' }
  end

  describe 'Gemfile with the correct' do
    describe 'rails version' do
      Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 6.1.7/ }
    end

    describe 'ruby version' do
      Then { assert_file 'Gemfile', /ruby ["']3.2.1["']/ }
    end

    describe 'db' do
      Then { assert_file 'Gemfile', /gem ["']pg["'], ["']~> 1.1/ }
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
      describe 'postgresql-dev' do
        Then { assert_file 'Dockerfile', /postgresql-dev/ }
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
        # Then { assert_file file, /\n\s\sapp:/ }
        # And { assert_file file, /\n\s\s\s\sbuild:/ }
        focus
        Then { assert_file file, /depends_on:\n\s\s\s\s\s\s- db/ }
        # Then { assert_file file, /\napp:\n\s\sdb_data/ }
      end
    end
    describe 'volumes' do
      Then { assert_file file, /\nvolumes:\n\s\sdb_data/ }
      And  { assert_file file, /\s\sgem_cache/ }
      And  { assert_file file, /\s\snode_modules/ }
    end

    describe 'database service' do
      describe 'database service' do
        Then { assert_file file, /\n\s\sdb:/ }

        describe 'image' do
          Then { assert_file file, /\n\s\s\s\simage: postgres:14.1/ }
        end
      end
    end
  end
end
