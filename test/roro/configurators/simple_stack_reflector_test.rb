# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('simple') }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  describe '#adventure_for(picks)' do
    Given(:adventure) { subject.adventure_for(*picks) }

    Given(:assert_expected_adventure) do
      expected_keys = %i[chapters itinerary picks tags title versions]
      expected_base_chapters = %w[alpine databases docker git redis]
      expected[:chapters] = expected_base_chapters + expected[:chapters] if expected[:chapters]
      adventure[:chapters].map! { |f| f.split('/').last.split('.yml').first }
      assert_equal(expected_keys, adventure.keys.sort)
      expected_keys.each do |key|
        assert_equal(expected[key], adventure[key]) if expected[key]
      end
    end

    describe 'when adventure is okonomi php laravel' do
      Given(:expected) do
        {
          chapters: %w[ruby _builder rails okonomi 6_1 sidekiq],
          # itinerary: [
          #   'unstoppable_developer_style: okonomi', 'language: php',
          #   'adventure: laravel'
          # ],
          # picks: [1, 1, 1],
          # tags: %w[alpine databases docker git redis okonomi php laravel],
          # title: [
          #   'unstoppable_developer_style: okonomi, language: php',
          #   'adventure: laravel'
          # ].join(', '),
          versions: { 'rails' => '6.1' }
        }
      end

      describe 'when picks is a string' do
        When(:picks) { '1 1 1' }
        Then { assert_expected_adventure }
      end
    end

    describe 'when adventure is okonomi ruby rails pg' do
      Given { skip }
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
      Given { skip }
      Given(:expected) do
        {
          chapters: %w[sashimi rails],
          itinerary: [
            'unstoppable_developer_style: sashimi', 'framework: rails'
          ],
          picks: [3, 2],
          tags: %w[
            alpine databases docker git redis sashimi
            rails
          ],
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
    Given { skip }
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
