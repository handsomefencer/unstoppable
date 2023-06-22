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
      keys = subject.reflection.keys
      assert_includes keys, :adventures
      assert_includes keys, :cases
      assert_includes keys, :itineraries
      assert_includes keys, :stack
      assert_includes keys, :structure
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
      expected_keys = %i[
        chapters itinerary partial_paths picks tags template_paths title versions
      ]
      expected_base_chapters = %w[alpine databases docker git redis]
      expected[:chapters] = expected_base_chapters + expected[:chapters]
      adventure[:chapters].map! { |f| f.split('/').last.split('.yml').first }
      adventure[:template_paths].map! { |f| f.split('/')[-2..-1].join('/') }
      adventure[:partial_paths].map! { |f| f.split('/')[-3..-1].join('/') }
      assert_equal(expected_keys, adventure.keys.sort)
      expected_keys.each do |key|
        assert_equal(expected[key], adventure[key]) if expected[key]
      end
    end

    describe 'when adventure is okonomi php laravel' do
      Given(:expected) do
        {
          chapters: %w[okonomi php laravel],
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: php',
            'adventure: laravel'
          ],
          partial_paths: ['laravel/templates/partials'],
          picks: [1, 1, 1],
          tags: %w[alpine databases docker git redis okonomi php laravel],
          title: [
            'unstoppable_developer_style: okonomi, language: php',
            'adventure: laravel'
          ].join(', '),
          template_paths: ['okonomi/templates', 'laravel/templates'],
          versions: {}
        }
      end

      describe 'when picks is a string' do
        When(:picks) { '1 1 1' }
        Then { assert_expected_adventure }
      end

      describe 'when picks arg is an array' do
        When(:picks) { [1, 1, 1] }
        Then { assert_expected_adventure }
      end
    end

    describe 'when adventure is okonomi ruby rails pg' do
      Given(:picks) { '1 3 1 1 2 2 2 2' }

      Given(:expected) do
        {
          chapters: %w[
            okonomi ruby databases rails postgres
            14_1 3_0 sidekiq 7_0
          ],
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: ruby',
            'framework: rails', 'database: postgres',
            'postgres version: 14_1', 'ruby version: 3_0',
            'scheduler: sidekiq', 'rails version: 7_0'
          ],

          partial_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '7_0/templates/partials'
          ],
          picks: [1, 3, 1, 1, 2, 2, 2, 2],
          tags: %w[
            alpine databases docker git redis okonomi ruby
            rails postgres sidekiq
          ],
          template_paths: ['okonomi/templates', 'rails/templates',
                           'postgres/templates', 'sidekiq/templates', '7_0/templates'],
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

    describe 'when adventure is sashimi rails' do
      Given(:expected) do
        {
          chapters: %w[sashimi rails],
          itinerary: [
            'unstoppable_developer_style: sashimi', 'framework: rails'
          ],
          partial_paths: [],
          picks: [3, 2],
          tags: %w[
            alpine databases docker git redis sashimi
            rails
          ],
          template_paths: ['rails/templates'],
          title: [
            'unstoppable_developer_style: sashimi, framework: rails'
          ].join(', '),
          versions: {}
        }
      end

      describe 'when picks arg is string' do
        When(:picks) { '3 2' }
        Then { assert_expected_adventure }
      end
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
