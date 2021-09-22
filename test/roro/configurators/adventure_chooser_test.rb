# frozen_string_literal: true

require 'test_helper'

describe AdventureChooser do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { 'roro'}
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:adventure)    { AdventureChooser.new(catalog_path) }
  let(:itinerary)    { adventure.itinerary }
  let(:catalog)      { 'roro' }

  context 'when catalog has no inflections' do
    When(:catalog) { 'roro/roro' }
    Then { assert_empty itinerary }
  end

  context 'when plot choice is' do
    let(:inflections) { [] }

    context 'php' do
      Given { inflections << %w[plots 2] }
      Given { assert_inflections(inflections) }
      Then  { assert_file_match_in('roro/plots/php', itinerary) }
    end

    context 'ruby and when story is' do
      Given { inflections << %w[plots 4] }

      context 'ruby_gem' do
        Given { inflections << %w[plots/ruby/stories 2] }
        Given { assert_inflections(inflections) }
        Then  { assert_file_match_in('roro/plots/ruby/stories/ruby_gem', itinerary) }
      end

      context 'rails and when' do
        Given { inflections << %w[plots/ruby/stories 1] }
        Given { inflections << %w[plots/ruby/stories/rails/flavors 2] }
        Given { inflections << %w[plots/ruby/stories/rails/databases 1] }
        Given { inflections << %w[plots/ruby/stories/rails/continuous_integration_strategies 1] }

        context 'flavor is rails_vue' do
          Given { assert_inflections(inflections) }
          Then  { assert_file_match_in('flavors/rails_react', itinerary)}
        end

        context 'database is mysql' do
          Given { assert_inflections(inflections) }
          Then  { assert_file_match_in('databases/mysql', itinerary)}
        end
      end
    end
  end
end
