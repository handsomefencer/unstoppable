# frozen_string_literal: true

require 'test_helper'

describe '' do
  Given(:workbench) { }

  Given { @rollon_loud    = true }
  Given { @rollon_dummies = true }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
    describe 'Dockerfile' do
      Given(:file) { 'Dockerfile' }
      Then { assert_file file }
    end

    describe 'composer.json' do
      Given(:file) { 'composer.json' }
      focus
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
