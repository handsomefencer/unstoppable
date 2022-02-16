# frozen_string_literal: true

require 'test_helper'

describe '' do
  Given(:workbench) { }

  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
    describe 'mise' do
      describe 'mise/env' do
        Then { assert_file 'mise/env/base.env'}
      end
    end

    describe 'docker-compose.yml with' do
      Given(:file) { 'docker-compose.yml' }

      describe 'correct docker-compose version' do
        Then { assert_file file, /version: '3.9'/ }
      end

      describe 'correct services' do
        Then { assert_includes read_yaml(file)[:services].keys, :web  }

        describe 'db' do
          Given(:db) { read_yaml(file)[:services][:db] }
          Then { assert_includes read_yaml(file)[:services].keys, :db  }

          describe 'image' do
            Then { assert_equal 'mysql:5.7', db[:image] }
          end

          describe 'volumes' do
            Then { assert_match 'db_data:/var/lib/mysql', db[:volumes][0] }
          end

          describe 'env_file' do
            Then { assert_match './mise/env/base.env', db[:env_file][0] }
          end
        end
      end
    end

    describe 'requirements.txt' do
      Given(:file) { 'requirements.txt' }
      Then {
        assert_file file, /Django==4.0.2/
        assert_file file, /mysqlclient==2.1.0/
        assert_file file, /psycopg2==2.9.3/
        assert_file file, /asgiref==3.5.0/
        assert_file file, /sqlparse==0.4.2/ }
    end

    describe 'app_name/settings.py' do
      Given(:file) { 'unstoppable_django/settings.py' }
      Then { assert_file file, /os.environ.get\('MYSQL_DATABASE'\)/ }
      Then { assert_file file, /os.environ.get\('MYSQL_USER'\)/ }
      Then { assert_file file, / os.environ.get\('MYSQL_PASSWORD'\)/ }
    end

    describe 'Dockerfile' do
      Given(:file) { 'Dockerfile' }

      describe 'must have content' do
        describe 'steps' do
          Then { assert_file file, /# syntax=docker/ }
        end

        describe 'steps' do
          Then { assert_file file, /\nFROM python:3/ }
          And  { assert_file file, /\nRUN pip install -r requirements.txt/ }
        end

        describe 'polished' do
          Then { refute File.exist?('polisher') }
        end
      end
    end
  end
end
