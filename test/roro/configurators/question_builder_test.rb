# frozen_string_literal: true

require 'test_helper'

describe QuestionBuilder do
  let(:options) { { inflection: stack_path } }
  let(:builder) { QuestionBuilder.new(options) }
  let(:stack)   { 'inflection' }

  describe '#inflection_prompt' do
    let(:inflection_prompt)  { builder.inflection_prompt }

    context 'when stack is /inflection' do
      Then { assert_match 'these valid inflections',  inflection_prompt }
    end

    context 'when stack is /stack/inflection' do
      When(:stack) { 'stack/inflection' }
      Then { assert_includes inflection_prompt, 'choose from these stack inflections' }
    end

    context 'when stack parent is rails and inflection is flavors' do
      When(:stack) { 'stack/stack/inflection/stack/inflection/rails/flavors' }
      Then { assert_includes inflection_prompt, 'choose from these rails flavors' }
    end
  end

  describe '#inflection_options' do
    let(:inflection_options) { builder.inflection_options }

    context 'when /inflection' do
      Then { assert_equal inflection_options.size, 2 }
      And  { assert_includes inflection_options.values, 'story' }
      And  { assert_includes inflection_options.values, 'story2' }
    end

    context 'when stack/stack/plots' do
      When(:stack) { 'stack/stack/plots' }
      Then { assert_equal 2, inflection_options.count }
      And  { assert_equal String, inflection_options.keys.first.class }
    end
  end

  describe '#get_story_preface' do
    let(:preface) { builder.get_story_preface(stack_path) }

    context 'when story has a preface' do
      When(:stack) { 'story' }
      Then { assert_match 'some string', preface }
    end

    context 'when story is nested  without a preface' do
      When(:stack) { 'stack/stack/stories/story' }
      Then { assert_nil preface }
    end
  end

  describe '#humanize_options(hash)' do
    let(:result) { builder.humanize(builder.inflection_options) }

    context 'when two stories' do
      let(:stack) { 'inflection' }
      Then { assert result.is_a?(String) }
      And  { assert_match '(1) story:', result}
      And  { assert_match '(2) story2:', result}
    end
  end

  describe '#question' do
    let(:question) { builder.build_from_inflection }
    Then { assert_equal Array, question.class }
    And  { assert_equal Hash, question.last.class }
    And  { assert_equal Array, question.last[:limited_to].class }
    And  { assert_match builder.inflection_prompt, question.first }
  end

  describe '#story_from(key, hash)' do
    let(:answer) { builder.story_from('1') }

    context 'when /inflection' do
      When(:stack) { 'inflection' }

      Then { assert_equal answer, 'story' }
    end

    context 'when /stack/inflection' do
      When(:stack) { 'stack/inflection' }
      Then { assert_equal answer, 'stacks_1' }
    end
  end
end
