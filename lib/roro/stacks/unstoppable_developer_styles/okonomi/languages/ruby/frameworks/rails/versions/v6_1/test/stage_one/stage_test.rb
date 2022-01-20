require 'test_helper'

describe 'okonomi ruby rails 7_0' do
  Given(:workbench) { 'empty' }
  Given(:cli)       { Roro::CLI.new }
  Given(:overrides) { %w[] }
  Given(:adventure) { 0 }
  Given(:rollon)    {
    copy_stage_dummy(__dir__)
    stubs_adventure(__dir__, adventure)
    stubs_dependencies_met?
    stubs_yes?
    stub_overrides
    # stub_run_actions
    cli.rollon
  }

  Given { rollon }

  describe 'must generate a' do
    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }

      context 'when sqlite' do
        focus
        Then  { assert_file 'docker-compose.yml', /postgres:13.5/ }
        And  { assert_file file, /var\/local-db/ }
      end

      context 'when postgres' do
        context 'when version 13.5' do
          Given(:adventure) { 3 }
          Then { assert_file 'docker-compose.yml', /postgres:13.5/ }
          And  { assert_file file, /var\/lib\/postgresql\/data/ }
        end

        context 'when version 14.1' do
          Given(:adventure) { 5 }
          Then { assert_file file, /image: postgres:14.1/ }
          And  { assert_file file, /var\/lib\/postgresql\/data/ }
        end
      end
    end

    describe 'Dockerfile' do
      describe 'ruby version' do
        context 'when 2.7.4 chosen' do
          Then  { assert_file 'Dockerfile', /FROM ruby:2.7.4-alpine/ }
        end

        context 'when 3.0 chosen' do
          Given(:adventure) { 1 }
          Then  { assert_file 'Dockerfile', /FROM ruby:3.0-alpine/ }
        end
      end

      describe 'alpine db pkg' do
        context 'when sqlite' do
          Then  { assert_file 'Dockerfile', /sqlite/ }
        end

        context 'when postgres' do
          Given(:adventure) { 4 }
          Then  { assert_file 'Dockerfile', /postgresql-dev/ }
        end
      end

      describe 'yarn install command' do
        Then   { assert_file 'Dockerfile', /RUN yarn install/ }
      end
    end
  end
end