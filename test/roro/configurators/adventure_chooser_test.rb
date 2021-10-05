# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:adventure)    { AdventureChooser.new }

  describe '#initialize' do
    describe '#stack' do
      Then { assert_equal Roro::CLI.catalog_root, adventure.stack }
    end

    describe '#itinerary' do
      Then { assert_equal [], adventure.itinerary}
    end
  end

  describe '#build_itinerary' do
    let(:inflections) { [] }
    let(:itinerary)   { adventure.build_itinerary(stack_path) }

    context 'when stack is story' do
      When(:stack) { 'story' }
      Then { assert_empty itinerary }
    end

    context 'when stack is storyfile' do
      When(:stack) { 'story/story.yml' }
      Then { assert_empty itinerary }
    end

    context 'when stack has no inflections' do
      When(:stack) { 'stack/story' }
      Then { assert_empty itinerary }
    end

    context 'when stack is inflection' do
      When(:stack) { 'stacks' }
      Given(:stub_journey) { Thor::Shell::Basic
                             .any_instance
                             .stubs(:ask)
                             .returns(*answers)}
    let(:answers) { %w[stacks_1 stack_2] }

      focus
      Given { stub_journey }
      Then  { assert_file_match_in('stacks/story', itinerary) }
      # And   { assert_equal 1, adventure.itinerary.size }
    end


    context 'when stack has one inflection' do
      before { skip }
      let(:inflections)  { [ %w[plots story]] }
      When(:stack) { 'stack/with_one_inflection' }
      Given { assert_inflections(inflections) }
      Then  { assert_file_match_in('plots/story', itinerary) }
    end

    context 'when stack has multiple inflections' do
      before { skip }
      When(:stack) { 'stack/stack' }
      Given { inflections << %w[plots story] }
      Given { inflections << %w[stories story] }
      Given { assert_inflections(inflections) }
      Then  { assert_file_match_in('plots/story', itinerary) }
      And   { assert_equal 2, adventure.itinerary.size }
    end
  end
end
