require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles sashimi stories rails' do
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[4 2] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    stub_adventure
    stub_overrides
    stub_run_actions
    stub_dependencies_installed
    # quiet { cli.rollon }
    cli.rollon
  }

  Given { rollon unless adventures.empty?}

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
