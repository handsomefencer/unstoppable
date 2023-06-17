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
          chapters: %w[ruby _builder rails postgres
                       okonomi 6_1 sidekiq],
          itinerary: [
            'database: postgres', 'style: okonomi', 'rails version: 6_1'
          ],
          picks: [1, 1, 1],
          tags: %w[
            alpine databases docker git redis ruby rails
            postgres okonomi sidekiq
          ],
          title: [
            'database: postgres, style: okonomi, rails version: 6.1'
          ].join(', '),
          versions: { 'rails' => '6.1' }
        }
      end
    end
  end
end
