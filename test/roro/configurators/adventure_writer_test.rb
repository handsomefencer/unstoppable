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
      Given(:itinerary) { itineraries[5]}

      describe 'must be using correct itinerary' do
        Then { assert_equal storyfile[0], itinerary.first }
        And  { assert_match /django\/databases\/postgres/, itinerary.first }
        And  { assert_match /python\/versions\/v3_10_1/, itinerary.last }
      end

      describe 'partials_for()' do
        context 'when file has immediate partials' do
          Then  { assert_equal 3, writer.partials_for(itinerary[0]).size }
        end

        context 'when file has no immediate partials' do
          Then  { assert_equal 2, writer.partials_for(itinerary[1]).size }
        end
      end

      describe 'partials' do
        Then { assert_equal 3, writer.partials.size }
      end

      describe '#section_partial(name)' do
        Then { assert_equal 2, writer.section_partials('services').size }
        And  { assert_match (/web/), writer.section_partials('services').first }
        And  { assert_match (/db/), writer.section_partials('services').last }
      end

      describe 'partials' do
        Then { assert_match ( /_packages.erb/), writer.partials[0]  }
        And  { assert_match (/_web/), writer.partials[1]  }
        And  { assert_match (/_db/), writer.partials[2]  }
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

  describe '#partial(name)' do
    describe 'must return interpolation from the most specific partial' do
      context 'when variable present' do
        Then { assert_match /PASSWORD=password/, writer.partial('web') }
      end
    end
  end

  describe '#manifest_paths' do
    Then { assert_match 'templates/manifest', writer.manifest_paths.first }
  end
end
