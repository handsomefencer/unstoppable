# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('alpha') }
  Given(:subject) { Roro::Configurators::StackReflector.new }

  Given(:adventure) { subject.adventure_for(*picks) }

  describe '#adventure_for()' do
    describe 'when adventure is okonomi php laravel' do
      Given(:expected) do
        {
          chapters: %w[okonomi php _builder laravel],
          choices: %w[okonomi php laravel],
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: php',
            'adventure: laravel'
          ],
          env: { base: { db_vendor: { value: 'postgres' } } },
          picks: [1, 1, 1],
          pretty_tags: %w[alpine databases docker git redis okonomi php laravel],
          tags: %w[alpine databases docker git redis okonomi php laravel],
          title: [
            'unstoppable_developer_style: okonomi, language: php',
            'adventure: laravel'
          ].join(', '),
          templates_partials_paths: ['laravel/templates/partials'],
          templates_paths: ['okonomi/templates', 'laravel/templates'],
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
      Given(:expected) do
        {
          chapters: %w[
            okonomi ruby _builder databases rails postgres
            13_5 sidekiq 7_0 3_0
          ],
          choices: %w[okonomi ruby rails postgres 13_5 sidekiq 7_0 3_0],
          env: {
            base: {
              db_vendor: {
                value: 'postgresql'
              },
              rails_version: {
                value: 6.1
              },
              db_image_version: {
                value: 13.5
              }
            }
          },
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: ruby',
            'framework: rails', 'database: postgres',
            'postgres version: 13_5', 'scheduler: sidekiq',
            'rails version: 7_0', 'ruby version: 3_0'
          ],

          partial_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '7_0/templates/partials'
          ],
          picks: [1, 3, 1, 1, 1, 2, 2, 2],
          tags: %w[
            alpine databases docker git redis okonomi ruby
            rails postgres sidekiq
          ],
          templates_partials_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '7_0/templates/partials'
          ],
          templates_paths: [
            'okonomi/templates', 'rails/templates',
            'postgres/templates', 'sidekiq/templates', '7_0/templates'
          ],
          title: [
            'unstoppable_developer_style: okonomi, scheduler: sidekiq',
            'postgres version: 13.5', 'rails version: 7.0', 'ruby version: 3.0'
          ].join(', '),
          versions: {
            'postgres' => '13.5', 'ruby' => '3.0', 'rails' => '7.0'
          }
        }
      end
      When(:picks) { '1 3 1 1 1 2 2 2' }
      Then { assert_expected_adventure }
    end

    describe 'when adventure is okonomi ruby rails sqlite' do
      Given(:expected) do
        {
          chapters: %w[
            okonomi ruby _builder databases rails sqlite
            resque 6_1 2_7
          ],
          choices: %w[okonomi ruby rails sqlite resque 6_1 2_7],
          env: {
            base: {
              db_vendor: {
                value: 'sqlite3'
              },
              rails_version: {
                value: 6.1
              },
              db_image_version: {
                value: 13.5
              }
            }
          },
          itinerary: [
            'unstoppable_developer_style: okonomi', 'language: ruby',
            'framework: rails', 'database: sqlite',
            'scheduler: resque',
            'rails version: 6_1', 'ruby version: 2_7'
          ],

          partial_paths: [
            'rails/templates/partials', 'postgres/templates/partials',
            '7_0/templates/partials'
          ],
          picks: [1, 3, 1, 2, 1, 1, 1],
          tags: %w[
            alpine databases docker git redis okonomi ruby
            rails sqlite resque
          ],
          templates_partials_paths: [
            'rails/templates/partials', 'sqlite/templates/partials',
            '6_1/templates/partials'
          ],
          templates_paths: [
            'okonomi/templates', 'rails/templates',
            'sqlite/templates', 'resque/templates', '6_1/templates'
          ],
          title: [
            'unstoppable_developer_style: okonomi', 'database: sqlite',
            'scheduler: resque', 'rails version: 6.1', 'ruby version: 2.7'
          ].join(', '),
          versions: {
            'rails' => '6.1', 'ruby' => '2.7'
          }
        }
      end
      # When(:picks) { '1 3 1 1 1 2 2 2' }
      When(:picks) { '1 3 1 2 1 1 1' }
      Then { assert_expected_adventure }
    end

    describe 'when adventure is sashimi rails' do
      Given(:expected) do
        {
          chapters: %w[sashimi rails],
          choices: %w[sashimi rails],
          env: { base: { db_vendor: { value: 'sqlite3' } } },
          itinerary: [
            'unstoppable_developer_style: sashimi', 'framework: rails'
          ],
          partial_paths: [],
          picks: [3, 2],
          tags: %w[
            alpine databases docker git redis sashimi
            rails
          ],
          templates_paths: ['rails/templates'],
          templates_partials_paths: [],
          title: [
            'unstoppable_developer_style: sashimi, framework: rails'
          ].join(', '),
          versions: {}
        }
      end

      describe 'when picks arg is string' do
        Given(:picks) { '3 2' }
        Then { assert_expected_adventure }
      end
    end
  end
end
