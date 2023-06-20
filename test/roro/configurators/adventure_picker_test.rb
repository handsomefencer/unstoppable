# frozen_string_literal: true

require 'test_helper'

describe 'AdventurePicker' do
  Given(:subject) { AdventurePicker.new }
  Given(:inflection) do
    ["#{Roro::CLI.test_root}/fixtures/files/stacks",
     'complex/unstoppable_developer_styles'].join('/')
  end

  describe '#choose_adventure()' do
    Given(:result) { subject.choose_adventure(inflection) }

    describe 'when okonomi' do
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

  describe '#inflection_prompt()' do
    Given(:result) { subject.inflection_prompt(inflection) }
    Then { assert_match('Please choose from these', result) }
    And { assert_match('complex unstoppable developer styles:', result) }
  end

  describe '#inflection_options()' do
    Given(:result) { subject.inflection_options(inflection) }

    Then do
      assert_equal 3, result.size
      assert_equal %w[1 2 3], result.keys
      assert_equal %w[okonomi omakase sashimi], result.values
    end
  end

  describe '#which_adventure?()' do
    Given(:result) { subject.which_adventure?(inflection) }
    Then { assert_match('Leave it to the chef', result) }
  end

  describe '#get_story_preface' do
    Given(:result) { subject.get_story_preface("#{inflection}/okonomi") }
    Then { assert_equal('Choose what you like.', result) }
  end
end
