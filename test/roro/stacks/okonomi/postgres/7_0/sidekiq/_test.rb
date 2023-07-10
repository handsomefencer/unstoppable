# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 3 postgres -> 2 7_0 -> 2 sidekiq' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
  focus
  Then do
    assert_stacked_stacks
    assert_stacked_okonomi
    assert_stacked_postgres
    assert_stacked_7_0
    assert_stacked_sidekiq
    f = 'docker-compose.yml'
    assert_yaml(f, :services, :app, :depends_on, 0, 'db')
    assert_yaml(f, :services, :db, :image, 'postgres:14.1')
    assert_yaml(f, :services, :db, :volumes, 0, %r{lib/postgresql/data})
    refute_file('Dockerfile')
    assert_file('mise/containers/app/Dockerfile')
    # assert_file(f, /DATABASE_NAME/)

    # assert_file(f, /RAILS_MAX_THREADS=5/)
    # assert_file('mise/containers/app/Dockerfile')
    # assert_file('mise/containers/app/env/development.env', /RAILS_MAX_THREADS=5/)
  end
end
