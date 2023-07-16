# frozen_string_literal: true

require_relative '../shared_tests'

describe '2: unstoppable_rails_style: omakase' do
  Given(:workbench) {}

  Given(:files) do
    ['.dockerignore',
     '.gitignore',
     '.keep',
     'Gemfile',
     'config/database.yml',
     'docker-compose.yml',
     'mise/env/base.env',
     'mise/env/development.env',
     'mise/env/production.env',
     'mise/containers/app/env/base.env',
     'mise/containers/app/env/development.env',
     'mise/containers/app/env/production.env',
     'mise/containers/app/Dockerfile',
     'test/application_system_test_case.rb',
     'test/test_helper.rb']
  end
  Given do
    insert_dummy_files(*files)
    rollon(__dir__)
  end

  focus
  Then do
    assert_stacked_stacks
    assert_stacked_sqlite
    assert_stacked_7_0
    refute_stacked_compose_service_redis
    refute_stacked_compose_service_sidekiq
  end
end
