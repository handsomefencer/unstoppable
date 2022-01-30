require 'test_helper'

describe 'adventure::rails_v7_0::2::postgres_v13_5 & ruby_v2_7' do
  Given(:workbench)  { }
  Given { @rollon_loud    = true }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }
 do
  Given(:workbench)  { 'empty' }
  # Given(:cli)        { Roro::CLI.new }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__)
    stubs_dependencies_met?
    stubs_yes?
    stub_overrides
    simulate_rollon
    run_rollon
  }

  # Given {  }
  Given { rollon }# Given { quiet { rollon } }

  describe 'must have a' do
    describe 'docker entrypoint' do
      focus
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
            focus
            Then  { assert_file file, /\n\s\s\s\simage: nouchka\/sqlite3:latest/ }
          end
        end
      end
    end
  end
end