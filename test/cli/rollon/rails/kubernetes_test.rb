require 'test_helper'

describe Roro::CLI do
  
  Given(:cli)     { Roro::CLI.new }
  Given(:config) { Roro::Configurator.new() }


  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }
  Given { stub_dependency_responses }

  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.rollon_rails_kubernetes }

  describe 'rollon rails kubernetes' do 
    Given(:options) { { story: 
      { rails: [
        { database:   { postgresql:   {} }},
        { kubernetes: { postgresql:   {} }},
        { ci_cd:      { circleci:     {} }} 
      ] } 
    } }

    Given { rollon }

    describe 'roro kube folder' do 

      Then { assert_directory "roro/kube" }
    end

    describe 'roro kube components' do 
      
      Then { assert_file "roro/kube/certificate.yml" }
      And  { assert_file "roro/kube/cluster-issuer.yml" }
      And  { assert_file "roro/kube/deployment.yml" }
      And  { assert_file "roro/kube/ingress.yml" }
      And  { assert_file "roro/kube/job-migrate.yml" }
      And  { assert_file "roro/kube/secret-digital-ocean.yml" }
      And  { assert_file "roro/kube/service.yml" }
    end

    describe 'rakefile' do 
      
      Then { assert_file "lib/tasks/kube.rake" }
    end
  end
end
