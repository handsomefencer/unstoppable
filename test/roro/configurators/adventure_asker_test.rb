# frozen_string_literal: true

require 'test_helper'

describe 'AskInflection' do
  let(:asker)            { AdventureAsker.new }
  let(:build_inflection) { asker.build_inflection(stack_path) }
  let(:stack)            { 'stacks' }

  Given { build_inflection }

  describe '#build_inflection' do
    Then { assert_equal Array, build_inflection.class }
    And  { assert_equal Hash, build_inflection.last.class }
    And  { assert_equal Array, build_inflection.last[:limited_to].class }
  end

  describe '#choose_adventure(inflection)' do
    let(:choose_adventure) { asker.choose_adventure(stack_path) }

    context 'when stacks' do
      Given { stub_journey(%w[1]) }
      Then  { assert_equal "#{stack_path}/story", choose_adventure }
    end

    context 'when stack/stack/ploss' do
      When(:stack) { 'stack/stack/plots' }
      Given { stub_journey(%w[1]) }
      Then  { assert_equal "#{stack_path}/story1", choose_adventure }
    end
  end

  describe '#inflection_prompt' do
    let(:prompt) { asker.inflection_prompt }

    context 'when stacks' do
      Then { assert_includes prompt, 'Please choose from these valid stacks:' }
    end

    context 'when stack/stacks' do
      When(:stack) { 'stack/stacks' }
      Then { assert_includes prompt, 'these stack stacks' }
    end

    context 'when stack parent is rails and inflection is flavors' do
      When(:stack) { 'stack/stack/inflection/stack/inflection/rails/flavors' }
      Then { assert_includes prompt, 'these rails flavors' }
    end
  end

  describe '#inflection_options' do
    let(:options) { asker.inflection_options }

    context 'when stacks' do
      Then { assert_equal options.size, 2 }
      And  { assert_includes options.values, 'story' }
      And  { assert_includes options.values, 'story2' }
    end

    context 'when stack/stack/plots' do
      When(:stack) { 'stack/stack/plots' }
      Then { assert_equal 2, options.count }
      And  { assert_equal String, options.keys.first.class }
    end
  end

  describe '#get_story_preface' do
    let(:preface) { asker.get_story_preface(stack_path) }

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
    let(:humanized) { asker.humanize(asker.inflection_options) }

    context 'when stacks' do
      Then { assert humanized.is_a?(String) }
      And  { assert_match '(1) story:', humanized}
      And  { assert_match '(2) story2:', humanized}
    end
  end

  describe '#story_from(key, hash)' do
    let(:story_from) { asker.story_from('1') }

    context 'when story' do
      Then { assert_equal 'story', story_from }
    end

    context 'when /stack/stacks' do
      When(:stack) { 'stack/stacks' }
      Then { assert_equal 'stacks_1', story_from }
    end
  end
end
