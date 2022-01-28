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
    stub_run_actions
    cli.rollon
  }

  Given { quiet { rollon } }

  describe 'must generate a' do
    describe 'Gemfile with the correct' do
      Given(:file) { 'Gemfile'}

      describe 'ruby version' do
        Then  { assert_file file, /ruby ['"]2.7.4['"]/ }
      end

      describe 'rails version' do
        Then  { assert_file file, /gem ['"]rails['"], ['"]~> 6.1.4/ }
      end

      describe 'sqlite version' do
        Then  { assert_file file, /gem ['"]sqlite3['"], ['"]~> 1.4['"]/ }
      end
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        Then  { assert_file 'Dockerfile', /FROM ruby:2.7/ }
      end

      describe 'bundler version' do
        Then   { assert_file 'Dockerfile', /gem install bundler:2.2.28/ }
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      describe 'sqlite service' do
        Then  { assert_file file, /sqlite3:/ }
      end

      describe 'sqlite image' do
        Then  { assert_file file, /image: nouchka\/sqlite3:latest/ }
      end
    end

    describe 'rails master key config' do
      Given(:file) { 'config/environments/production.rb' }
      Then  { assert_file file, /# config.require_master_key = true/ }
    end

    describe 'entrypoints/docker-entrypoint.sh' do
      Given(:file) { 'entrypoints/docker-entrypoint.sh' }

      describe 'must exist' do
        Then  { assert_file file }
      end

      describe 'must have correct permissions' do
        Then  { assert File.owned?(file)  }
      end
    end
  end
end