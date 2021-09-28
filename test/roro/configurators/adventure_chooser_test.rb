# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:adventure)    { AdventureChooser.new }

  describe '#new' do
    describe 'instance variables' do
      describe 'catalog' do
        Then { assert_equal Roro::CLI.catalog_root, adventure.catalog }
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
      Then { assert_empty itinerary }
    end

    context 'when stack is stack' do
      When(:stack) { 'stack' }

      context 'story2' do
        Given { inflections << %w[stack/stacks_1 stacks_1] }
        Given { assert_inflections(inflections) }
        # focus
        # Then  { assert_file_match_in('stacks/story2', itinerary) }
        # focus
        # Then  { assert_file_match_in('stacks/story2', itinerary) }
      end

      context 'story2' do
        Given { inflections << %w[stack/inflection/stacks_1 stacks_1] }
        Given { assert_inflections(inflections) }
        focus
        # Then  { assert_file_match_in('inflection/stackss_1s', itinerary) }
      end
    end
    context 'when plot choice is' do
      context 'php' do
        # Given { inflections << ['inflection/story', 'story'] }
  #       Given { inflections << %w[fatsufodo/stories] }
        Given { inflections << %w[inflection story] }
        Given { assert_inflections(inflections) }
        # Then  { assert_file_match_in('inflection/story', itinerary) }
      end
  #
  #     context 'ruby and when story is' do
  #       Given { inflections << %w[plots 4] }
  #
  #       context 'ruby_gem' do
  #         Given { inflections << %w[plots/ruby/stories 2] }
  #         Given { assert_inflections(inflections) }
  #         # Then  { assert_file_match_in('roro/plots/ruby/stories/ruby_gem', itinerary) }
  #       end
  #
  #       context 'rails and when' do
  #         Given { inflections << %w[plots/ruby/stories 1] }
  #         Given { inflections << %w[plots/ruby/stories/rails/flavors 2] }
  #         Given { inflections << %w[plots/ruby/stories/rails/databases 1] }
  #         Given { inflections << %w[plots/ruby/stories/rails/continuous_integration_strategies 1] }
  #
  #         Given { assert_inflections(inflections) }
  #
  #         context 'flavor is rails_vue' do
  #           # Then  { assert_file_match_in('flavors/rails_react', itinerary)}
  #         end
  #
  #         context 'database is mysql' do
  #           # Then  { assert_file_match_in('databases/mysql', itinerary)}
  #         end
  #
  #         context 'ci strategy is circleci' do
  #           # Then  { assert_file_match_in('databases/mysql', itinerary)}
  #         end
  #
  #         context 'all inflections handled' do
  #           When(:paths) { %w[rails_react mysql circleci] }
  #           # Then { assert_itinerary_in(paths, [itinerary]) }
  #           # And  { assert_equal 3, itinerary.size}
  #         end
  #       end
  #     end
  #
  #     #   context 'when catalog is an alias' do
  #   #     let(:catalog)      { 'inflection' }
  #   #
  #   #     Given { inflections << %w[plots 2] }
  #   #     Given { assert_inflections(inflections) }
  #   #     Then { assert_file_match_in('flavors/rails', itinerary) }
  #   #     # Then { assert_file_match_in('flavors/rails', itinerary) }
  #   #   end
  #   #
  #   #
    end
  end
end
