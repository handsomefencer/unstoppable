# frozen_string_literal: true

require 'test_helper'

describe '' do
  Given(:workbench) { }

  Given { @rollon_loud    = true }
  Given { @rollon_dummies = true }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
    describe 'docker' do
      Then { assert_file 'docker/default.conf' }
      And  { assert_file 'docker/scheduler.sh' }

      describe 'php.dockerfile' do
        Given(:file) { 'docker/php.dockerfile' }
        focus
        Then { assert_file file, /FROM php:7.4-fpm-alpine/ }
      end
    end

    describe 'composer.json' do
      Given(:file) { 'composer.json' }
      Then {
        assert_file file }
        # assert_file 'docker-compose.yml' }
    end

    describe 'docker-compose.yml' do
      Given(:file) { 'docker-compose.yml' }
      Then { assert_file file }
    end
  end


  describe 'other string' do
  end
end
