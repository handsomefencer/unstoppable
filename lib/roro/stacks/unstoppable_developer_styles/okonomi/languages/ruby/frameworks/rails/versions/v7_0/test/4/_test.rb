require 'test_helper'

describe 'adventure::rails-v7_0::3 postgres-v13_5 & ruby-v3_0' do
  Given(:workbench)  { }
  Given { @rollon_loud    = true }
  Given { @rollon_dummies = true }
  Given { rollon(__dir__) }

  describe 'must have a' do
    describe 'docker entrypoint' do
      Then  { assert_file 'entrypoints/docker-entrypoint.sh' }
    end

    describe 'config/database.yml' do
      Given(:file) { 'config/database.yml' }
      describe 'with postgres docker' do
        focus
        Then  { assert_file file, /<%= ENV\.fetch\('DATABASE_HOST'\)/ }
      end
    end

    describe 'mise-en-place' do
      Then { assert_file 'mise/env/base.env' }
    end

    describe 'Gemfile with the correct' do
      describe 'rails version' do
        Then { assert_file 'Gemfile', /gem \"rails\", \"~> 7.0.2/ }
      end

      describe 'db' do
        Then { assert_file 'Gemfile', /gem ["']pg["'], ["']~> 1.1/ }
      end
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        Then { assert_file 'Dockerfile', /FROM ruby:2.7/ }
      end

      describe 'bundler version' do
        Then { assert_file 'Dockerfile', /bundler:2.2.28/ }
      end

      describe 'alpine db packages' do
        describe 'postgresql' do
          Then { assert_file 'Dockerfile', /postgresql-dev/ }
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
          Then  { assert_file file, /\n\s\sdb:/ }

          describe 'image' do

            Then  { assert_file file, /\n\s\s\s\simage: postgres:14.1/ }
          end
        end
      end
    end
  end
end