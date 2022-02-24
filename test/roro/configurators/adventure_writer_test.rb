# frozen_string_literal: true

require 'test_helper'

describe 'AdventureWriter' do
  Given(:workbench) { }
  Given(:writer)    { AdventureWriter.new }

  Given { writer.instance_variable_set(:@env, buildenv[:env]) }
  Given { writer.instance_variable_set(:@buildenv, buildenv) }
  Given { writer.instance_variable_set(:@storyfile, storyfile[0]) }

  Given(:itinerary)   { itineraries[5]}
  Given(:itineraries) { -> (index) { Reflector.new.itineraries[index] } }
  Given(:storyfile)   { -> (index) { itinerary[index] } }
  Given(:buildenv)    { {
    itinerary: itinerary,
    env: {
      base: {
        POSTGRES_PASSWORD: { value: 'password' },
        db_pkg: { value: 'sqlite' },
        db_vendor: { value: 'sqlite' },
        ruby_version: { value: '3.0' } } } } }

  context 'django' do
    describe 'must return correct' do
      Given(:itinerary) { itineraries[6]}

      describe 'must be using correct itinerary' do
        Given { skip }
        Then { assert_equal storyfile[0], itinerary.first }
        And  { assert_match /django\/databases\/postgres/, itinerary.first }
        And  { assert_match /python\/versions\/v3_10_1/, itinerary.last }
      end

      describe 'partials_for()' do
        context 'when file has immediate partials' do
          Given { skip }
          Then  { assert_equal 4, writer.partials_for(itinerary[0]).size }
        end

        context 'when file has no immediate partials' do
          Then  { assert_equal 0, writer.partials_for(itinerary[1]).size }
        end
      end

      describe 'partials' do
        Given { skip }
        Then { assert_equal 4, writer.partials.size }
      end

      describe '#section_partial(name)' do
        Given { skip }
        Then { assert_equal 2, writer.section_partials('services').size }
        And  { assert_match (/web/), writer.section_partials('services').first }
        And  { assert_match (/db/), writer.section_partials('services').last }
      end
    end

    describe '#section(name)' do
      context 'when section not present' do
        Then { assert_raises(Roro::Error) { writer.section ('not_present') } }
      end

      describe 'must return interpolation from the most specific partial' do
        Given(:section) { writer.section('services') }
        # Then { assert_match 'db', section }
      end
    end
  end

  describe '#manifest_paths' do
    Then { assert_match 'templates/manifest', writer.manifest_paths.first }
  end

  describe '#template_paths' do
    context 'django' do
      # Then { assert_equal 3, writer.template_paths.size }

      describe 'must include parents' do
        # Then { assert_match 'okonomi/templates', writer.template_paths[0] }
        # And  { assert_match 'python/templates', writer.template_paths[1] }
      end

      describe 'must include self' do
        # Then { assert_match 'django/templates', writer.template_paths[2] }
      end
    end
  end

  describe '#template_paths' do
    context 'when rails-v6_1::0 sqlite & ruby-v2_7' do
      Given(:itinerary)      { itineraries[12]}
      Given(:template_paths) { writer.template_paths }
      Given(:result)         { writer.template_paths_for(stack) }

      describe 'must have correct itinerary' do
        Given { skip }
        Then { assert_equal 3, itinerary.size }
        And  { assert_match 'rails/databases/sqlite', itinerary[0] }
        And  { assert_match 'rails/versions/v7_0', itinerary[1] }
        And  { assert_match 'ruby/versions/v2_7', itinerary[2] }
      end

      describe '#template_paths' do
        Given { skip }
        Then { assert_equal 4, template_paths.size }
        And  { assert_match 'okonomi/templates', template_paths[0] }
        And  { assert_match 'frameworks/rails/templates', template_paths[1] }
        And  { assert_match 'databases/sqlite/templates', template_paths[2] }
        And  { assert_match 'versions/v7_0/templates', template_paths[3] }
      end

      describe '#template_paths_for(stack)' do
        context 'when stack is rails/versions/v7_0' do
          Given(:stack)     { itinerary[1] }

          describe 'must return correct number of template paths' do
            Then { assert_equal 3, result.size }
          end

          describe 'must return grandparent' do
            Then { assert_match 'okonomi/templates', result[0] }
          end

          describe 'must return grandparent' do
            Then { assert_match 'frameworks/rails/templates', result[1] }
          end

          describe 'must return self' do
            Given { skip }
            Then { assert_match 'versions/v7_0/templates', result[2] }
          end
        end

        context 'when stack is databases/sqlite' do
          Given(:stack)     { itinerary[0] }

          describe 'must return correct number of template paths' do
            Then { assert_equal 3, result.size }
          end

          describe 'must return grandparent' do
            Then { assert_match 'okonomi/templates', result[0] }
          end

          describe 'must return grandparent' do
            Then { assert_match 'frameworks/rails/templates', result[1] }
          end

          describe 'must return self' do
            Given { skip }
            Then { assert_match 'databases/sqlite/templates', result[2] }
          end
        end
      end
    end
  end
end
