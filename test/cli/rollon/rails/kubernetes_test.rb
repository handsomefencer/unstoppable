require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }

  Given(:config) { Roro::Configuration.new }
  Given(:subject){ Roro::CLI.new }
  Given(:rollon) { 
    subject.instance_variable_set(:@config, config)
    subject.rollon_rails_kubernetes }

  describe 'rollon rails kubernetes' do 

    Given { rollon }

    describe 'roro kube folder' do 

      Then { assert_directory "roro/kube" }
    end

    describe 'roro kube components' do 
      
      Then { assert_file "roro/kube/certificate.yml" }
      Then { assert_file "roro/kube/cluster-issuer.yml" }
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
