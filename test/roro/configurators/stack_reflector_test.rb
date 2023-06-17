# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('complex') }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  describe '#initialize' do
    Then do
      assert subject.adventures
      assert subject.cases
      assert subject.reflection
      assert subject.stack
    end

    And do
      assert_match 'stacks/complex', subject.stack
      assert_includes subject.reflection.keys, :adventures
      assert_includes subject.reflection.keys, :stack
      assert_includes subject.reflection.keys, :structure
    end
  end

  describe '#cases' do
    Given(:result) { subject.cases }
    Given(:expected_cases) { expected_adventure_cases }

    describe 'must return the correct number of cases' do
      Then { assert_equal 38, result.size }
    end

    describe 'must return the expected cases' do
      Then { expected_cases.each { |e| assert_includes result, e } }
    end

    describe 'must return the correct order of cases' do
      Then { assert_equal(expected_cases, result) }
    end
  end

  describe '#adventures' do
    Given(:expected) { expected_adventure_cases }
    Given(:result) { subject.adventures }

    describe 'must return a Hash' do
      Then { assert_equal Hash, result.class }
    end

    describe 'must return the correct number of adventures' do
      Then { assert_equal expected_adventure_cases.size, result.size }
    end
  end

  describe '#adventure_for(picks)' do
    Given(:adventure) { subject.adventure_for(*picks) }

    Given(:assert_expected_adventure) do
      expected[:chapters] = %w[alpine databases docker git redis] + expected[:chapters]
      adventure[:chapters].map! { |f| f.split('/').last.split('.yml').first }
      expected_keys = %i[chapters itinerary picks tags title versions]
      assert_equal(expected_keys, adventure.keys.sort)
      expected_keys.each do |key|
        assert_equal(expected[key], adventure[key]) if expected[key]
      end
    end

    Given(:assert_expected_keys) do
      assert_includes(adventure.keys, :chapters)
      assert_includes(adventure.keys, :picks)
      assert_includes(adventure.keys, :itinerary)
      assert_includes(adventure.keys, :tags)
    end

    Given(:assert_expected_picks) do
      assert_equal(expected[:picks], adventure[:picks])
    end

    Given(:assert_expected_itinerary) do
      assert_equal(expected[:itinerary], adventure[:itinerary]) if expected[:itinerary]
    end

    Given(:assert_expected_chapters) do
      expected_chapters = %w[alpine databases docker git redis] + expected[:chapters]
      if expected[:chapters]
        assert_equal(expected_chapters.size, adventure[:chapters].size)
        assert_equal(expected_chapters, adventure[:chapters].map { |f| f.split('/').last.split('.yml').first })
      end
    end

    Given(:assert_expected_tags) do
      assert_equal(expected[:tags], adventure[:tags]) if expected[:tags]
    end

    Given(:assert_expected_title) do
      assert_equal(expected[:title], adventure[:title]) if expected[:title]
    end

    Given(:assert_expected_versions) do
      assert_equal(expected[:versions], adventure[:versions]) if expected[:versions]
    end

    describe 'must handle string or array picks arg' do
      Given(:expected) { { picks: [1, 1, 1] } }
      Given(:picks) { '1 1 1' }

      describe 'when picks arg is a string' do
        Then { assert_expected_picks }
      end

      describe 'when picks arg is an array' do
        Given(:picks) { [1, 1, 1] }
        Then { assert_expected_picks }
      end
    end

    describe 'when adventure is okonomi php laravel' do
      Given(:picks) { '1 1 1' }

      Given(:expected) do
        {
          chapters: %w[okonomi php _builder laravel],
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: php',
            'adventure: laravel'
          ],
          picks: [1, 1, 1],
          tags: %w[alpine databases docker git redis okonomi php laravel],
          title: [
            'unstoppable_developer_style: okonomi, language: php',
            'adventure: laravel'
          ].join(', '),
          versions: {}
        }
      end
      Then { assert_expected_adventure }
    end

    describe 'when adventure is okonomi ruby rails pg' do
      Given(:picks) { '1 3 1 1 2 2 2 2' }

      Given(:expected) do
        {
          chapters: %w[
            okonomi ruby _builder databases rails postgres
            14_1 3_0 sidekiq 7_0
          ],
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: ruby',
            'framework: rails', 'database: postgres',
            'postgres version: 14_1', 'ruby version: 3_0',
            'scheduler: sidekiq', 'rails version: 7_0'
          ],
          picks: [1, 3, 1, 1, 2, 2, 2, 2],
          slug: 'some-slug',
          tags: %w[
            alpine databases docker git redis okonomi ruby
            rails postgres sidekiq
          ],
          title: [
            'unstoppable_developer_style: okonomi, scheduler: sidekiq',
            'postgres version: 14.1, ruby version: 3.0, rails version: 7.0'
          ].join(', '),
          versions: {
            'postgres' => '14.1', 'ruby' => '3.0', 'rails' => '7.0'
          }
        }
      end
      Then { assert_expected_adventure }
    end

    describe 'when adventure is okonomi ruby rails pg' do
      Given(:picks) { '3 2' }

      Given(:expected) do
        {
          picks: [3, 2],
          chapters: %w[sashimi rails],
          itinerary: [
            'unstoppable_developer_style: sashimi', 'framework: rails'
          ],
          tags: %w[
            alpine databases docker git redis sashimi
            rails
          ]
        }
      end

      Then { assert_expected_adventure }
    end
  end

  describe '#adventure_structure' do
    describe 'must return a hash with nested hash under :choices' do
      Given(:choices) { subject.structure.dig(:choices) }
      Then { assert_equal([1, 2, 3], choices.keys) }
      And { assert_equal({}, choices.dig(1, 3, 2, 1)) }
    end

    describe 'must return a hash with nested hash under :human' do
      Given(:human) { subject.structure.dig(:human) }
      Then { assert_equal(%w[okonomi omakase sashimi], human.keys) }
      And { assert_equal({}, human.dig('okonomi', 'php', 'laravel')) }
    end
  end
end
