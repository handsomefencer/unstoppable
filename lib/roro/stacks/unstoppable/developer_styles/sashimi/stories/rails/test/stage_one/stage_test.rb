require 'test_helper'

describe 'sashimi rails' do
  Given(:workbench) { 'empty' }
  Given(:cli)       { Roro::CLI.new }
  Given(:overrides) { %w[] }

  Given(:rollon)    {
    copy_stage_dummy __dir__
    stubs_adventure  __dir__
    stub_overrides
    stub_run_actions
    cli.rollon
  }

  Given { quiet { rollon } }

  Given(:contents) { [ /version: '3'/, /entrypoints\/sidekiq-entrypoint\.sh/] }

  describe 'docker-compose.yml' do
    When(:installed) { false }
    Then { contents.each { |c| assert_file "docker-compose.yml", c } }
  end

  describe 'k8s manifests' do
    Then { assert_file "k8s/app-deployment.yaml", /image: handsomefencer\/rails-kubernetes/  }
    And  { assert_file "k8s/database-deployment.yaml", /name: database-secret/  }
    And  { assert_file "k8s/secret.yaml", /DATABASE_NAME: cG9zdGdyZXM=/ }
  end
end
