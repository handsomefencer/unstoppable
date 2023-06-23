# frozen_string_literal: true

require 'test_helper'
require 'helpers/reflection_helpers'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('bravo') }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  Given(:adventure) { subject.adventure_for(*picks) }

  describe '#adventure_for()' do
    describe 'when adventure is okonomi php laravel' do
      Given(:expected) do
        {
          chapters: %w[ruby rails postgres okonomi 6_1 sidekiq],

          env: { base: { db_vendor: { value: 'postgresql' } } },
          itinerary: [
            'database: postgres',
            'style: okonomi', 'rails version: 6_1'
          ],

          partial_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '7_0/templates/partials'
          ],
          picks: [1, 1, 1],
          tags: %w[
            alpine databases docker git redis ruby
            rails postgres okonomi sidekiq
          ],
          templates_partials_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '6_1/templates/partials'
          ],
          templates_paths: [
            'rails/templates', 'postgres/templates', '6_1/templates', 'sidekiq/templates'
          ],
          title: [
            'database: postgres, style: okonomi, rails version: 6.1'
          ].join(', '),
          versions: {
            'rails' => '6.1'
          }
        }
      end
      When(:picks) { '1 1 1' }
      Then { assert_expected_adventure }
    end
  end
end
