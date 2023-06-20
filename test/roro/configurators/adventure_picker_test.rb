# frozen_string_literal: true

require 'test_helper'

describe 'AdventurePicker' do
  Given { use_fixture_stack('complex') }
  Given(:subject) { AdventurePicker.new }

  describe '#choose_adventure()' do
    Given(:result) { subject.choose_adventure(inflection) }
    Given(:inflection_options) { subject.inflection_options(inflection) }

    Invariant { assert_equal developer_styles, inflection_options.values }

    describe 'when okonomi' do
      Invariant { assert_equal 'okonomi', inflection_options.values.first }
      Given { stub_journey(%w[1]) }
      Then { assert_equal '1', result }
    end

    describe 'when omakase' do
      Given { stub_journey(%w[2]) }
      Then { assert_equal '2', result }
    end

    describe 'when sashimi' do
      Given { stub_journey(%w[3]) }
      Then { assert_equal '3', result }
    end
  end

  describe '#build_inflection()' do
    Given(:result) { subject.build_inflection(inflection) }

    describe 'must return a hash with correct keys' do
      Then { assert_includes(result.keys, :prompt) }
      Then { assert_includes(result.keys, :choose_from) }
    end

    describe ':prompt' do
      Then { assert_equal expected.dig(:prompt), result.dig(:prompt).strip }
    end

    describe ':choices' do
      Then do
        assert_match(
          expected.dig(:choose_from, 0), result.dig(:choose_from, 0)
        )
      end
    end
  end

  Given(:fixture_stacks) { "#{Roro::CLI.test_root}/fixtures/files/stacks" }
  Given(:fixture_stack) { "#{fixture_stacks}/complex" }
  Given(:inflection) { "#{fixture_stack}/unstoppable_developer_styles" }
  Given(:story) { "#{inflection}/okonomi" }
  Given(:storyfile) { "#{story}/okonomi.yml" }
  Given(:developer_styles) { %w[okonomi omakase sashimi] }

  Given(:expected) do
    {
      prompt: 'Please choose from these complex unstoppable developer styles:',
      choose_from: %w[omakase okonomi]
    }
  end

  describe '#inflection_prompt()' do
    Given(:expected) { 'Please choose from these complex unstoppable' }
    Given(:result) { subject.inflection_prompt(inflection) }

    Then { assert_match(expected, result) }
  end

  describe '#inflection_options()' do
    Given(:result) { subject.inflection_options(inflection) }

    focus
    Then do
      assert_equal 3, result.size
      assert_equal %w[1 2 3], result.keys
      assert_equal %w[okonomi omakase sashimi], result.values
    end

    describe '#humanize()' do
      Given(:humanized_result) { subject.humanize(inflection, result) }
      Then { assert_match('Leave it to the chef', humanized_result) }
    end
  end

  describe '#get_story_preface' do
    Given(:result) { subject.get_story_preface(story) }
    Then { assert_equal('Choose what you like.', result) }
  end
end
