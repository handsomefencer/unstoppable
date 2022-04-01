# frozen_string_literal: true

require 'test_helper'

describe '' do
  Given(:workbench) { }

  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
    describe 'requirements.txt' do
      Given(:file) { 'requirements.txt' }
      Then { assert_file file }
  
      describe 'must have content' do 
        describe 'equal to' do 
          Then { assert_file file, 'foo' }
        end

        describe 'matching' do 
          Then { assert_file file, /foo/ }
          Then { assert_content file, /foo/ }
        end
      end
    end
  end


  describe 'directory must contain' do
    describe 'docker-compose.yml with' do
      Given(:file) { 'docker-compose.yml' }

      describe 'correct docker-compose version' do
        Then { assert_file file, /version: '3.9'/ }
      end

      describe 'correct services' do
        Then { assert_includes read_yaml(file)[:services].keys, :db  }
        And  { assert_includes read_yaml(file)[:services].keys, :web  }

        describe 'db' do
          Given(:db) { read_yaml(file)[:services][:db] }

          describe 'image' do
            Then { assert_equal 'postgres', db[:image] }
          end

          describe 'volumes' do
            Then { assert_match ':/var/lib/postgresql/data', db[:volumes][0] }
          end
        end
      end
    end

    describe 'requirements.txt' do
      Given(:file) { 'requirements.txt' }
      Then { assert_file file, /asgiref==3.5.0/ }
      And  { assert_file file, /psycopg2==2/ }
      And  { assert_file file, /sqlparse==0.4.2/ }
      And  { assert_file file, /Django==4.0.2/ }
    end

    describe 'app_name/settings.py' do
      Given(:file) { 'unstoppable_django/settings.py' }
      Then { assert_file file, /'ENGINE': 'django.db.backends.postgresql'/ }
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

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      describe 'must have content' do 
        describe 'matching' do
          Then { assert_file file, /version: '3.9'/ }
        end
      end
    end
  end
end
