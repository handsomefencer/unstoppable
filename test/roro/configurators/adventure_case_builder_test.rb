# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  before { skip }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { 'roro'}
  # let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:case_builder) { AdventureCaseBuilder.new }

  describe '#build_itineraries' do
    let(:itineraries) { case_builder.build_itineraries(catalog_path) }

    context 'when catalog contains' do
      let(:paths)   { [] }

      context 'one inflection when first inflection has' do
        let(:catalog) { 'roro/plots/python' }

        context 'a parent with two story paths' do
          describe 'must return two itineries' do
            Then { assert_equal 2, itineraries.size }
          end

          describe 'must return django itinerary' do
            Given { paths << 'roro/plots/python/stories/django' }
            Then  { assert_itinerary_in(paths, itineraries) }
          end

          describe 'must return correct last case' do
            Given { paths << 'roro/plots/python/stories/flask' }
            Then  { assert_itinerary_in(paths, itineraries) }
          end
        end
      end

      context 'a parent with two inflections' do
        let(:catalog) { 'roro/plots/ruby/stories/rails' }

        describe 'must return 12 inflections' do
          Then { assert_equal 12, itineraries.size }
        end

        describe 'must return correct first inflection' do
          Given { paths << 'rails/flavors/rails' }
          Given { paths << 'rails/databases/mysql' }
          Then  { assert_itinerary_in(paths, itineraries) }
        end

        describe 'must return correct last inflection' do

          Then { assert_itinerary_in(['rails/flavors/rails'], itineraries) }
          And  { assert_itinerary_in(['rails/databases/postgres'], itineraries) }
        end
      end

      context 'nested inflections' do
        let(:catalog) { 'roro' }

        describe 'must return 17 itineraries' do
          Then { assert_equal 17, itineraries.size }
        end

        describe 'must return correct first inflection' do
          When(:itinerary) { itineraries.first }
          Then { assert_itinerary_in(['roro/plots/php'], itineraries) }
        end

        describe 'must return correct last inflection' do
          Then { assert_itinerary_in(['python/stories/flask'], itineraries) }
        end
      end
    end
  end
end
