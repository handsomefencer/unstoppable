# frozen_string_literal: true

require 'stack_test_helper'

describe 'Roro::TestHelpers::StackReflectorTestHelper' do
  # include Roro::TestHelpers::StackReflectorTestHelper

  Given(:adventure) { adventure_fixture }
  Given(:expected) {
    {
      chapters: %w[okonomi],
      choices: %w[okonomi rails sqlite],
      itinerary: [ 'unstoppable_developer_style: okonomi'],
      env: { base: { db_vendor: { value: 'sqlite' } } },
      picks: [1, 1, 1],
      pretty_tags: %w[alpine databases docker git redis okonomi php laravel],
      tags: %w[alpine okonomi rails sqlite],
      title: [
        'unstoppable_developer_style: okonomi, database: sqlite'
      ].join(', '),
      templates_partials_paths: ['rails/templates/partials'],
      templates_paths: ['okonomi/templates', 'rails/templates', 'sqlite/templates'],
      versions: { rails: '6.1', ruby: '2.7' }
    }
  }

  Then {
    assert_expected_chapters
    assert_expected_choices
    assert_expected_env
    assert_expected_keys
    assert_expected_templates_partials_paths
    assert_expected_templates_paths
  }

  And { assert_expected_adventure }
end
