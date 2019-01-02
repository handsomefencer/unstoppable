require 'test_helper'

describe "Roro::CLI" do

  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'dummy_roro' }

  Given { subject.generate_keys }
  Given { subject.obfuscate }

  Given(:env_files) { HandsomeFencer::Crypto.source_files('.', '.env') }

  describe ":expose(environment)" do

    Given { env_files.each { |file| FileUtils.rm file } }
    Given { env_files.each { |file| refute_file file } }

    describe "with key_file" do

      Given { subject.expose('development') }

      Then { assert_file 'docker/containers/app/development.env' }

      And { refute_file 'docker/containers/app/production.env' }
    end

    describe "with ENV_KEY" do

      Given(:passkey) { File.read 'docker/keys/circleci.key' }
      Given { ENV['CIRCLECI_KEY'] = passkey }
      Given { FileUtils.rm 'docker/keys/circleci.key' }
      Given { subject.expose('circleci') }

      Then { assert_file 'docker/env_files/circleci.env' }

    end
  end

  describe ":expose" do

    Given { env_files.each { |file| FileUtils.rm file } }
    Given { env_files.each { |file| refute_file file } }
    Given { subject.expose }

    Then { env_files.each { |file| assert_file file } }
  end
end
