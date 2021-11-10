require 'test_helper'

describe 'lib roro stacks catalog unstoppable developer_styles devops ci_styles circleci circleci' do
  Given { skip }
  Given(:workbench)  { 'empty' }
  Given(:cli)        { Roro::CLI.new }
  Given(:adventures) { %w[1 1] }
  Given(:overrides)  { %w[] }

  Given(:rollon)    {
    # copy_stage_dummy(__dir__)
    stub_adventure
    stub_overrides
    stub_run_actions
    # cli.rollon
  }

  Given { rollon unless adventures.empty?}

  describe 'must generate a' do
    Given(:app_name) { 'unstoppable_devops' }
    Given(:org_name) { 'your-dockerhub-organization' }
    Given(:image)    { "#{org_name}/#{app_name}" }

    describe 'scripts directory with ci-deploy.sh' do
      Then  { assert_file './scripts/ci-deploy.sh', /k8s\/app-deployment.yml/ }
    end

    describe '.circleci directory with config.yml' do
      Then  { assert_file './.circleci/config.yml', /IMAGE_NAME: #{image}/ }
    end

    describe 'k8s directory with' do
      describe 'app-deployment.yml' do
        Then  { assert_file './k8s/app-deployment.yml', /image: #{image}/ }
      end

      describe 'app-service.yml' do
        Then  { assert_file './k8s/app-service.yml', /app: #{app_name}/ }
        And   { assert_file './k8s/app-service.yml', /name: #{app_name}/ }
      end
    end

    describe 'kube-general folder with' do
      describe 'cicd-service-account.yml' do
        Given(:kind) { 'kind: ServiceAccount' }
        Then  { assert_file 'k8s-general/cicd-service-account.yml', /#{kind}/ }
      end

      describe 'cicd-service-account.yml' do
        Given(:kind) { 'kind: ServiceAccount' }
        Then  { assert_file 'k8s-general/cicd-service-account.yml', /#{kind}/ }
      end
    end

    describe '.gitignore' do
      Given(:ignoreds) { %w[
        /log/*
        /tmp/*
        /tmp/pids/*
        !/tmp/pids/
        /k8s-general/
        \*.env
        \*.key
      ] }
      Then  { ignoreds.each { |i| assert_file '.gitignore', /#{i}/ } }
    end
  end
end