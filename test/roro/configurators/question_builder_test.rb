# frozen_string_literal: true

require 'test_helper'
require 'stringio'

describe QuestionBuilder do
  let(:builder)  { QuestionBuilder.new(options) }
  let(:env_hash) { read_yaml(stack_path)[:env] }

  describe '#build_overrides_from_storyfile' do
    let(:result)   { builder.build_overrides_from_storyfile }
    When(:stack)   { 'story/story.yml'}
    When(:options) { { storyfile: stack_path } }
    Then { assert_equal env_hash[:development], result[:development] }

    describe '#override(hash)' do
      context 'when name' do
        let(:env_key)   { :SOME_KEY }
        let(:env_value) { { :value=>"somevalue", :help=>"some_url"} }

        context 'supplied interpolates name into prompt' do
          Given { env_value[:name] = "some environment variable name" }
          Then { assert_match 'value for some env', builder.override(env_key, env_value).first }
        end

        context 'not supplied interpolates key into prompt' do
          Then { assert_match 'value for SOME_KEY', builder.override(env_key, env_value).first }
          Then { assert_equal 'value for SOME_KEY', builder.override(env_key, env_value).first }
        end
      end
    end
  end


  describe '#inflection_prompt' do
    let(:inflection_prompt)  { builder.inflection_prompt }

    context 'when stack is /stacks' do
      # Then { assert_match 'these valid stacks',  inflection_prompt }
    end

    context 'when stack is /stack/stacks' do
      When(:stack) { 'stack/stacks' }
      # Then { assert_includes inflection_prompt, 'choose from these stack stacks' }
    end

    context 'when stack parent is rails and inflection is flavors' do
      When(:stack) { 'stack/stack/inflection/stack/inflection/rails/flavors' }
      # Then { assert_includes inflection_prompt, 'choose from these rails flavors' }
    end
  end

  describe '#build_inflection' do
    let(:options)            { { inflection: stack_path } }
    let(:humanized)          { builder.humanize(builder.inflection_options) }
    let(:inflection_options) { builder.inflection_options }
    let(:preface)            { builder.get_story_preface(stack_path) }
    let(:question)           { builder.build_inflection }
    let(:story_from)         { builder.story_from('1') }
    let(:stack)              { 'stacks' }

    describe '#get_story_preface' do
      context 'when story has' do
        context 'a preface' do
          When(:stack) { 'story' }
          Then { assert_match 'some string', preface }
        end

        context 'when story is nested without a preface' do
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
      Then { assert humanized.is_a?(String) }
      And  { assert_match '(1) story:', humanized }
      And  { assert_match '(2) story2:', humanized }
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

    describe '#humanize_options(hash)' do
      context 'when two stories' do
        Then { assert humanized.is_a?(String) }
        And  { assert_match '(1) story:', humanized}
        And  { assert_match '(2) story2:', humanized}
      end
    end

    describe '#question' do
      Then { assert_equal Array, question.class }
      And  { assert_equal Hash, question.last.class }
      And  { assert_equal Array, question.last[:limited_to].class }
      And  { assert_match builder.inflection_prompt, question.first }
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
