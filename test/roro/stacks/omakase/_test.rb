# frozen_string_literal: true

require_relative '../shared_tests'

describe '2: unstoppable_rails_style: omakase' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_sqlite
    assert_stacked_7_0
    refute_stacked_compose_service_redis
    refute_stacked_compose_service_sidekiq
  end
end
