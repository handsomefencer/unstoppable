# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('charlie') }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  describe '#adventure_for(picks)' do
    Given(:adventure) { subject.adventure_for(*picks) }

    describe 'when adventure is okonomi php laravel' do
      Given(:expected) do
        {
          chapters: %w[ruby _builder rails okonomi postgres
                       6_1 sidekiq],
          env: { base: { db_vendor: { value: 'postgresql' } } },
          itinerary: [
            'unstoppable_rails_style: okonomi', 'database: postgres',
            'rails version: 6_1'
          ],
          picks: [1, 1, 1],
          tags: %w[
            alpine databases docker git redis ruby rails
            okonomi postgres sidekiq
          ],
          title: [
            'database: postgres, rails version: 6.1'
          ].join(', '),
          templates_partials_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '6_1/templates/partials'
          ],
          templates_paths: [
            'rails/templates', 'postgres/templates', '6_1/templates',
            'sidekiq/templates'
          ],

          versions: { 'rails' => '6.1' }
        }
      end

      describe 'when picks is a string' do
        Given(:picks) { '1 1 1' }
        Then { assert_expected_adventure }
      end
    end
  end
end
