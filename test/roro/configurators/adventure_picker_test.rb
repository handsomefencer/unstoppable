# frozen_string_literal: true

require 'stack_test_helper'

describe 'AdventurePicker' do
  Given(:subject) { AdventurePicker.new }
  Given(:inflection) do
    ["#{Roro::CLI.test_root}/fixtures/files/stacks",
     'alpha/unstoppable_developer_styles'].join('/')
  end

  Given(:result) do
    quiet { subject.choose_adventure(inflection) }
  end

  describe '#choose_adventure()' do
    describe 'when okonomi' do
      Given { stub_journey(%w[1]) }
      Then { assert_equal '1', result }
    end

    describe 'when omakase' do
      Given { stub_journey(%w[2]) }
      Then { assert_equal '2', result }
    end

  end

  describe '#inflection_prompt()' do
    Given(:result) do
      quiet { subject.inflection_prompt(inflection) }
    end
    Then { assert_match('Please choose from these', result) }
    And { assert_match('alpha unstoppable developer styles:', result) }
  end

  describe '#inflection_options()' do
    Given(:result) do
      quiet { subject.inflection_options(inflection) }
    end

    Then do
      assert_equal 3, result.size
      assert_equal %w[1 2 3], result.keys
      assert_equal %w[okonomi omakase sashimi], result.values
    end
  end

  describe '#which_adventure?()' do
    Given(:result) do
      quiet { subject.which_adventure?(inflection) }
    end
    Then { assert_match('Leave it to the chef', result) }
  end

  describe '#get_story_preface' do
    Given(:result) do
      quiet { subject.get_story_preface("#{inflection}/okonomi") }
    end
    Then { assert_equal('Choose what you like.', result) }
  end
end
