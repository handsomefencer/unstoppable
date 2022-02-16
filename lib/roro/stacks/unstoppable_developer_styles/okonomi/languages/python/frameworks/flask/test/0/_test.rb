# frozen_string_literal: true

require 'test_helper'

describe '' do
  Given(:workbench) { }

  Given { @rollon_loud    = true }
  Given { @rollon_dummies = true }
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

        describe 'web' do
          Then { assert_includes read_yaml(file)[:services].keys, :redis  }
        end
      end
    end

    describe 'requirements.txt' do
      Given(:file) { 'requirements.txt' }
      Then {
        assert_file file, /Flask/
        assert_file file, /redis/ }
    end

    describe 'app.py' do
      Given(:file) { 'app.py' }
      Then { assert_file file }
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
      end
    end
  end
end
