# frozen_string_literal: true

require 'test_helper'
require 'stringio'

describe QuestionBuilder do
  Given(:builder)  { QuestionBuilder.new(options) }
  Given(:env_hash) { read_yaml(stack_path)[:env] }
  Given(:stack)    { 'story/story.yml' }
  Given(:options)  { { storyfile: stack_path } }

  describe '#build_overrides_from_storyfile' do
    describe '#override(hash)' do
      context 'when name' do
        Given(:env_key)   { :SOME_KEY }
        Given(:env_value) { { value: 'somevalue', help: 'some_url' } }

        context 'supplied must interpolate name into prompt' do
          Given { env_value[:name] = 'some environment variable name' }
          Then { assert_match 'name: some environment', builder.override(:development, env_key, env_value) }
        end

        context 'not supplied must interpolate key into prompt' do
          Then { assert_match 'name: SOME_KEY', builder.override(:development, env_key, env_value) }
        end
      end
    end
  end

  describe '#build_inflection' do
    Given(:options)            { { inflection: stack_path } }
    Given(:humanized)          { builder.humanize(builder.inflection_options) }
    Given(:inflection_options) { builder.inflection_options }
    Given(:inflection_prompt)  { builder.inflection_prompt }
    Given(:preface)            { builder.get_story_preface(stack_path) }
    Given(:question)           { builder.build_inflection }
    Given(:story_from)         { builder.story_from('1') }
    Given(:stack)              { 'stacks' }

    describe '#inflection_prompt' do
      context 'when stacks' do
        When(:stack)    { 'stacks' }
        When(:expected) { 'Please choose from these valid stacks:' }
        Then { assert_includes inflection_prompt, expected }
      end

      context 'when stack/stacks' do
        When(:stack) { 'stack/stacks' }
        Then { assert_includes inflection_prompt, 'these stack stacks' }
      end

      context 'when stack parent is rails and inflection is flavors' do
        When(:stack) { 'stack/stack/inflection/stack/inflection/rails/flavors' }
        Then { assert_includes inflection_prompt, 'these rails flavors' }
      end
    end

    describe '#inflection_options' do
      Then { assert_equal inflection_options.size, 2 }
      And  { assert_includes inflection_options.values, 'story' }
      And  { assert_includes inflection_options.values, 'story2' }

      context 'when stack/stack/plots' do
        When(:stack) { 'stack/stack/plots' }
        Then { assert_equal 2, inflection_options.count }
        And  { assert_equal String, inflection_options.keys.first.class }
      end
    end

    describe '#get_story_preface' do
      context 'when story' do
        context 'has a preface' do
          When(:stack) { 'story' }
          Then { assert_match 'some string', preface }
        end

        context 'has a preface and is nested' do
          When(:stack) { 'stacks/story' }
          Then { assert_match 'some string', preface }
        end

        context 'has no preface' do
          When(:stack) { 'stack/stack/stories/story' }
          Then { assert_nil preface }
        end
      end
    end

    describe '#humanize_options(hash)' do
      context 'when two stories' do
        Then { assert humanized.is_a?(String) }
        And  { assert_match '(1) story:', humanized }
        And  { assert_match '(2) story2:', humanized }
      end
    end

    describe '#question' do
      Then { assert_equal Array, question.class }
      And  { assert_equal Hash, question.last.class }
      And  { assert_equal Array, question.last[:limited_to].class }
      And  { assert_match inflection_prompt, question.first }
    end

    describe '#story_from(key, hash)' do
      Then { assert_equal 'story', story_from }

      context 'when /stack/stacks' do
        When(:stack) { 'stack/stacks' }
        Then { assert_equal 'stacks_1', story_from }
      end
    end
  end
end
