require 'test_helper'

describe 'adventure::rails-v7_0::0 sqlite & ruby-v3_0' do
  Given(:workbench)  { }
  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }

  describe 'must have a' do
    describe 'config/database.yml' do
      describe 'with sqlite' do
        Then  { assert_file 'config/database.yml',   /database: db\/test\.sqlite3/ }
      end
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

      describe 'ruby version' do
        Then { assert_file file, /FROM ruby:3.0/ }
      end

      describe 'alpine db packages' do
        describe 'sqlite' do
          Then { assert_file 'Dockerfile', /sqlite-dev/ }
        end
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }


      describe 'database service' do
        describe 'database service' do
          Then  { assert_file file, /\n\s\sdb:/ }

          describe 'image' do
            Then  { assert_file file, /\n\s\s\s\simage: nouchka\/sqlite3:latest/ }
          end

          describe 'env_file' do
            Then { assert_file file, /\n\s\s\s\senv_file:/ }
            And  { assert_file file, /\n\s\s\s\s\s\s- \.\/mise\/env\/base.env/ }
          end
        end
      end
    end
  end
end