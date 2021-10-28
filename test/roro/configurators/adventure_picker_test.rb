# frozen_string_literal: true

require 'test_helper'

describe 'AdventurePicker' do
  Given(:asker)            { AdventurePicker.new }
  Given(:build_inflection) { quiet { asker.build_inflection(stack_path) } }
  Given(:stack)            { 'stacks' }

  Given { build_inflection }

  describe '#build_inflection' do
    Then { assert_equal Array, build_inflection.class }
  end

  describe '#choose_adventure(inflection)' do
    Given(:choose_adventure) { quiet { asker.choose_adventure(stack_path) } }

    context 'when stacks' do
      Given { stub_journey(%w[1]) }
      Then  { assert_equal "#{stack_path}/story", choose_adventure }
    end

    context 'when stack/stack/plots' do
      When(:stack) { 'stack/stack/plots' }
      Given { stub_journey(%w[1]) }
      Then  { assert_equal "#{stack_path}/story1", choose_adventure }
    end
  end

  describe '#inflection_prompt' do
    Given(:prompt) { asker.inflection_prompt }

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
    Given(:options) { asker.inflection_options }

    context 'when valid/stack/stacks' do
      # TODO: Do we want to allow an inflection to have templates and stacks?
      Given(:stack)            { 'stack/stacks' }
      Then { assert_equal options.size, 2 }
      And  { assert_includes options.values, 'stacks_1' }
      And  { assert_includes options.values, 'stacks_2' }
    end

    context 'when stack/stack/plots' do
      When(:stack) { 'stack/stack/plots' }
      Then { assert_equal 2, options.count }
      And  { assert_equal String, options.keys.first.class }
    end
  end

  describe '#get_story_preface' do
    Given(:preface) { asker.get_story_preface(stack_path) }

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
    Given(:humanized) { asker.humanize(asker.inflection_options) }

    context 'when stacks' do
      Then { assert humanized.is_a?(String) }
      And  { assert_match 'story', humanized}
    end
  end

  describe '#story_from(key, hash)' do
    Given(:story_from) { asker.story_from('1') }

    context 'when story' do
      Then { assert_equal 'story', story_from }
    end

    context 'when /stack/stacks' do
      When(:stack) { 'stack/stacks' }
      Then { assert_equal 'stacks_1', story_from }
    end
  end
end
