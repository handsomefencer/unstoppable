require 'test_helper'

describe 'adventure::cert_manager::0 circleci' do
  Given { skip }
  Given(:workbench)  { }
  Given { @rollon_loud    = true }
  Given { @rollon_dummies = true }
  Given { rollon(__dir__) }

  describe 'k8s manifests' do
    Then { assert_file "k8s/app-deployment.yaml", /image: handsomefencer\/rails-kubernetes/  }
    # And  { assert_file "k8s/database-deployment.yaml", /name: database-secret/  }
    # And  { assert_file "k8s/secret.yaml", /DATABASE_NAME: cG9zdGdyZXM=/ }
  end
end
