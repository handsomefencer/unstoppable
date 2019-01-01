require 'test_helper'

describe "Roro::CLI" do

  Given(:subject) { Roro::CLI.new }
  Given!(:prepare) {
    prepare_destination
    FileUtils.cp_r "../dummy_roro", "."
    Dir.chdir 'dummy_roro' }

  Given { subject.generate_keys }
  Given { subject.obfuscate }
  Given { FileUtils.rm('docker/containers/app/circleci.env')}
  Given { FileUtils.rm('docker/containers/app/development.env')}

  describe "start" do

    Then {
      refute_file 'docker/containers/app/development.env'
      assert_file 'docker/containers/app/development.env.enc'
    }
  end

  describe ":expose(environment)" do

    # Given { assert_file 'docker/containers/app/production.env' }
    Given { subject.expose('development') }

    Then {
      assert_file 'docker/containers/app/development.env' }
    end
  #
  #   And {
  #     refute_file 'docker/containers/app/production.env.enc'
  #   }
  # end
  #
  # describe ":obfuscate" do
  #
  #   Given { subject.obfuscate }
  #
  #   Then {
  #     assert_file 'docker/containers/app/development.env.enc'
  #     assert_file 'docker/containers/web/development.env.enc'
  #     assert_file 'docker/containers/web/production.env.enc' }
  # end
end
