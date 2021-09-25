# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  before { skip }
  let(:adventure)    { AdventureChooser.new }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/rollable" }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }

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
    let(:itinerary)   { adventure.build_itinerary(catalog_path) }
    let(:catalog)     { 'styles'}

    context 'when catalog is an alias' do
      let(:catalog_root) {  "#{Dir.pwd}/test/fixtures/stacks" }
      let(:catalog)      { 'fatsufodo/stories/rails/rails.yml' }

      Given { inflections << %w[plots 2] }
      Given { assert_inflections(inflections) }
      Then { assert_file_match_in('flavors/rails', itinerary) }
    end

    context 'when catalog has no inflections' do
      When(:catalog) { 'roro/roro' }
      Then { assert_empty itinerary }
    end

    context 'when plot choice is' do
      context 'php' do
        Given { inflections << [nil, 'fatsufodo'] }
        Given { inflections << %w[fatsufodo/stories] }
        # Given { inflections << %w[omakase/roro/plots php] }
        Given { assert_inflections(inflections) }
        # Then  { assert_file_match_in('roro/plotdds/php', itinerary) }
      end

      context 'ruby and when story is' do
        Given { inflections << %w[plots 4] }

        context 'ruby_gem' do
          Given { inflections << %w[plots/ruby/stories 2] }
          Given { assert_inflections(inflections) }
          # Then  { assert_file_match_in('roro/plots/ruby/stories/ruby_gem', itinerary) }
        end

        context 'rails and when' do
          Given { inflections << %w[plots/ruby/stories 1] }
          Given { inflections << %w[plots/ruby/stories/rails/flavors 2] }
          Given { inflections << %w[plots/ruby/stories/rails/databases 1] }
          Given { inflections << %w[plots/ruby/stories/rails/continuous_integration_strategies 1] }

          Given { assert_inflections(inflections) }

          context 'flavor is rails_vue' do
            # Then  { assert_file_match_in('flavors/rails_react', itinerary)}
          end

          context 'database is mysql' do
            # Then  { assert_file_match_in('databases/mysql', itinerary)}
          end

          context 'ci strategy is circleci' do
            # Then  { assert_file_match_in('databases/mysql', itinerary)}
          end

          context 'all inflections handled' do
            When(:paths) { %w[rails_react mysql circleci] }
            # Then { assert_itinerary_in(paths, [itinerary]) }
            # And  { assert_equal 3, itinerary.size}
          end
        end
      end
    end
  end
end
