require 'test_helper'

describe 'adventure::rails-v7_0::0 sqlite & ruby-v2_7' do
  Given(:workbench)  { }
  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }

  describe 'must have a' do
    describe 'docker entrypoint' do
      Then  { assert_file 'entrypoints/docker-entrypoint.sh' }
    end

    describe 'config/database.yml' do
      describe 'with sqlite' do
        Then  { assert_file 'config/database.yml' }
      end
    end

    describe 'mise-en-place' do
      Then { assert_file 'mise/env/base.env' }
    end

    describe 'Gemfile with the correct' do
      describe 'rails version' do
        Then  { assert_file 'Gemfile', /gem \"rails\", \"~> 7.0.2/ }
      end

      describe 'db' do
        Then  { assert_file 'Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/ }
      end
    end

    describe 'Dockerfile' do
      Given(:file) { 'Dockerfile' }

      describe 'syntax' do
        focus

        Then { assert_file file, /# syntax=docker\/dockerfile:1/ }
      end

      describe 'ruby version' do
        Then { assert_file file, /FROM ruby:2.7/ }
      end

      describe 'packages' do
        Then { assert_file file, /RUN apk add / }
      end

      describe 'bundler version' do
        Then { assert_file 'Dockerfile', /bundler:2.2.28/ }
      end

      describe 'alpine db packages' do
        describe 'sqlite' do
          Then { assert_file 'Dockerfile', /sqlite-dev/ }
        end

        describe 'node' do
          Then { assert_file 'Dockerfile', /nodejs/ }
        end
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      describe 'volumes' do

        Then { assert_file file, /\nvolumes:\n\s\sdb_data/ }
        And  { assert_file file, /\s\sgem_cache/ }
        And  { assert_file file, /\s\snode_modules/ }
      end

      describe 'database service' do
        describe 'database service' do
          Then  { assert_file file, /\n\s\sdatabase:/ }

          describe 'image' do
            Then  { assert_file file, /\n\s\s\s\simage: nouchka\/sqlite3:latest/ }
          end
        end
      end
    end
  end
end