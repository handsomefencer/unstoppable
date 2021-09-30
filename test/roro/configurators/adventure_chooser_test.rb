# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:adventure)    { AdventureChooser.new }

  describe '#new' do
    describe 'instance variables' do
      describe 'catalog' do
        Then { assert_equal Roro::CLI.catalog_root, adventure.stack }
      end

      describe 'itinerary' do
        Then { assert_equal [], adventure.itinerary}
      end
    end
  end

  describe '#build_itinerary' do
    let(:inflections) { [] }
    let(:itinerary)   { adventure.build_itinerary(stack_path) }

    context 'when stack is story' do
      When(:stack) { 'story' }
      Then { assert_file_match_in('valid/story', itinerary) }
    end

    context 'when stack is storyfile' do
      When(:stack) { 'story/story.yml' }
      Then { assert_empty itinerary }
    end

    context 'when stack has no inflections' do
      When(:stack) { 'stack/story' }
      Then { assert_file_match_in('stack/story', itinerary) }
    end

    context 'when stack is inflection' do
      When(:stack) { 'stacks' }

      context 'story' do
        Given { inflections << %w[valid/stacks story] }
        Given { assert_inflections(inflections) }
        Then  { assert_file_match_in('stacks/story', itinerary) }
      end

      context 'story2' do
        Given { inflections << %w[valid/stacks story2] }
        Given { assert_inflections(inflections) }
        Then  { assert_file_match_in('stacks/story', itinerary) }
      end
    end
  end
end
