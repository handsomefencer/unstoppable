require 'test_helper'

describe "#{adventure_name(__FILE__)}" do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[] }
  Given(:adventure)  { 0 }

  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__)
    stubs_dependencies_met?
    stubs_yes?
    stub_overrides
    # stub_run_actions
    cli.rollon
  }

  # Given { quiet { rollon } }
  Given { rollon }

  describe 'must have a' do
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
        Then  { assert_file 'Gemfile', /gem \"rails\", \"~> 7.0.1/ }
      end

      describe 'db' do
        Then  { assert_file 'Gemfile', /gem ["']sqlite3["'], ["']~> 1.4/ }
      end
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        Then { assert_file 'Dockerfile', /FROM ruby:2.7/ }
      end

      describe 'bundler version' do
        Then { assert_file 'Dockerfile', /bundler:2.2.28/ }
      end

      describe 'alpine db package' do
        Then { assert_file 'Dockerfile', /sqlite-dev/ }
      end

      describe 'yarn install command' do
        Then { assert_file 'Dockerfile', /RUN yarn install/ }
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
        Then  { assert_file file, /database:/ }
      end

      describe 'sqlite image' do
        Then  { assert_file file, /image: nouchka\/sqlite3:latest/ }
      end
    end
  end
end