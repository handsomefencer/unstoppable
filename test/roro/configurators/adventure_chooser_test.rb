# frozen_string_literal: true

require 'test_helper'

describe 'AdventureChooser' do
  Given(:adventure) { AdventureChooser.new }

  describe '#initialize' do
    describe '#stack' do
      Then { assert_equal Roro::CLI.stacks, adventure.stack }
    end

    describe '#itinerary' do
      Then { assert_equal [], adventure.itinerary}
    end
  end

  describe '#build_itinerary' do
    Given(:answers) { %w[1] }
    Given(:itinerary)       { adventure.itinerary }
    Given(:manifest)        { adventure.manifest }
    Given(:build_itinerary) do
      stub_journey(answers)
      quiet { adventure.build_itinerary(stack_path) }
    end

    context 'when stack is story' do
      When(:stack) { 'story' }
      Given { build_itinerary }
      Then  { assert_equal 1, itinerary.size }
      And   { assert_equal 8, manifest.size }
    end

    context 'when stack is storyfile' do
      When(:stack) { 'story/story.yml' }
      Given { build_itinerary }
      Then  { assert_empty itinerary }
      And   { assert_equal 1, manifest.size }
    end

    context 'when stack has no inflections' do
      When(:stack) { 'stack/story' }
      Given { build_itinerary }
      Then  { assert_equal 1, itinerary.size }
      And   { assert_equal 1, manifest.size }
    end

    context 'when stack is inflection' do
      When(:stack)   { 'stacks' }
      When(:answers) { %w[1] }

      Given { build_itinerary }
      Then  { assert_file_match_in('stacks/story', itinerary) }
      And   { assert_equal 1, adventure.itinerary.size }
      And   { assert_equal 1, adventure.manifest.size }
    end

    context 'when stack has one inflection' do
      When(:stack) { 'stack/with_one_inflection' }
      Given { build_itinerary }
      Then  { assert_file_match_in('plots/story', itinerary) }
      Then  { assert_equal 1, itinerary.size }
      Then  { assert_equal 2, manifest.size }
    end

    context 'when stack has multiple inflections' do
      Given(:stack) { 'stack/stack' }

      context 'when 1,1' do
        When(:answers) { %w[1 1] }
        Given { build_itinerary }
        Then  { assert_file_match_in('plots/story1', itinerary) }
        Then  { assert_file_match_in('stories/story1', itinerary) }
        And   { assert_equal 3, itinerary.size }
        And   { assert_equal 4, manifest.size }
      end

      context 'when 1,2' do
        When(:answers) { %w[1 2] }
        Given { build_itinerary }
        Then  { assert_equal 3, itinerary.size }
        And   { assert_file_match_in('plots/story1', itinerary) }
        And   { assert_file_match_in('stories/story2', itinerary) }
      end

      context 'when 2,1' do
        When(:answers) { %w[2 1] }
        Given { build_itinerary }
        Then  { assert_equal 3, itinerary.size }
        And   { assert_file_match_in('plots/story2', itinerary) }
        And   { assert_file_match_in('stories/story1', itinerary) }
      end

      context 'when 2,2' do
        When(:answers) { %w[2 2] }
        Given { build_itinerary }
        Then  { assert_equal 3, itinerary.size }
        And   { assert_file_match_in('plots/story2', itinerary) }
        And   { assert_file_match_in('stories/story2', itinerary) }
      end
    end
  end
end
