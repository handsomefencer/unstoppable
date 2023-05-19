# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_harvest' do
  Given { skip }
  Given(:subject)        { Roro::CLI.new }
  Given(:workbench)      { 'harvest' }

  Given { subject.generate_harvest }

  describe 'must generate .harvest.yml' do
    Then { assert_file '.harvest.yml' }

    describe 'with content' do
      Given(:content) { read_yaml('.harvest.yml') }

      describe 'title' do
        # Given(:title) { content[:metadata][:adventures][:"8"][:title] }
        Given(:title) { content }
        # focus
        Then { assert_match(/docker postgres:13.5 rails:6.1 ruby:2.7/, title) }
      end

      describe 'tech_tags' do
        Given(:tags) { content[:metadata][:adventures][:"5"][:tech_tags] }
        Then { assert_includes tags, 'python' }
        And  { assert_includes tags, 'python:3.9.9' }
      end

      describe 'unversioned_tech_tags' do
        Given(:tags) { content[:metadata][:adventures][:"5"][:unversioned_tech_tags] }
        Then { assert_includes tags, 'python' }
        And  { refute_includes tags, 'python:3.9.9' }
      end

      describe 'versioned_tech_tags' do
        Given(:tags) { content[:metadata][:adventures][:"5"][:versioned_tech_tags] }
        Then { refute_includes tags, 'python' }
        And  { assert_includes tags, 'python:3.9.9' }
      end
    end
  end
end
