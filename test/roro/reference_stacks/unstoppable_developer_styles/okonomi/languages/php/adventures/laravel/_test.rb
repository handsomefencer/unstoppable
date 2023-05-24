# frozen_string_literal: true

require 'test_helper'

describe 'unstoppable_developer_styles: okonomi & languages: php & adventures: laravel' do
  Given(:workbench) {}

  Given do
    skip
    @rollon_dummies = true
    # @rollon_dummies = false
    rollon(__dir__)
  end

  describe 'directory must contain' do
    describe 'composer.json' do
      Given(:file) { 'composer.json' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'equal to' do
          Then { assert_file file, %r{laravel/laravel} }
        end
      end
    end

    describe 'docker/default.conf' do
      Given(:file) { 'docker/default.conf' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'matching' do
          Then { assert_file file, /listen 80/ }
        end
      end
    end

    describe 'docker/php.dockerfile' do
      Given(:file) { 'docker/php.dockerfile' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'matching' do
          Then { assert_file file, /turbo-dev/ }
        end
      end
    end

    describe 'docker/scheduler.sh' do
      Given(:file) { 'docker/scheduler.sh' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'matching' do
          Then { assert_file file, %r{php /var/www} }
        end
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'equal to' do
          Then { assert_file file, 'foo' }
        end

        describe 'matching' do
          Then { assert_file file, /foo/ }
          # Then { assert_content file, /foo/ }
        end
      end
    end
  end

  describe 'directory must contain' do
    describe 'docker' do
      Then { assert_file 'docker/default.conf' }
      And  { assert_file 'docker/scheduler.sh' }

      describe 'php.dockerfile must have correct' do
        Given(:file) { 'docker/php.dockerfile' }

        describe 'php version' do
          Then { assert_file file, /FROM php:7.4-fpm-alpine/ }
        end

        describe 'db package' do
          Then { assert_file file, /\n  postgresql-dev/ }
        end

        describe 'php extensions' do
          Then { assert_file file, /\n  pdo_pgsql/ }
        end

        describe 'redis' do
          Then { assert_file file, /\nRUN pecl install -o -f redis/ }
        end
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }
      Given(:data) { read_yaml(file) }
      Then { assert_file file }
      And { assert_includes data.keys, :version }
      And { assert_includes data.keys, :networks }

      describe 'services' do
        Then do
          assert_includes data[:services].keys, :artisan
          assert_includes data[:services].keys, :composer
          assert_includes data[:services].keys, :npm
          assert_includes data[:services].keys, :php
          assert_includes data[:services].keys, :postgres
          assert_includes data[:services].keys, :redis
          assert_includes data[:services].keys, :scheduler
          assert_includes data[:services].keys, :site
          assert_includes data[:services].keys, :worker
        end
      end
    end
  end
end
