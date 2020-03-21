require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'dummy_roro' }

  describe "generate_key" do

    Given { subject.generate_key('circleci') }

    Then { assert_file 'docker/keys/circleci.key' }

    And { refute_file 'docker/keys/production.key' }
  end

  describe "generate_keys" do

    Given { subject.generate_key }

    Then {
      assert_file 'docker/keys/circleci.key'
      assert_file 'docker/keys/production.key'
      assert_file 'docker/keys/staging.key'
      assert_file 'docker/keys/development.key' }
  end

  describe "gather_environments" do

    Given(:actual) { subject.gather_environments }

    Then { %w(circleci production).each { |env| assert_includes actual, env } }
  end

  describe ":confirm_files_decrypted()" do

    describe "when .env.enc file has matching .env file" do

      Then { assert subject.confirm_files_decrypted?('circleci') }
    end

    Given(:error) { Roro::Error }

    describe "when .env.enc file has matching .env file" do

      Given { FileUtils.rm('docker/env_files/circleci.env') }

      Then { assert_raises( error ) {
        subject.confirm_files_decrypted? 'circleci' } }

      describe "when called from generate_key" do

        Then { assert_raises( error ) {
          subject.generate_key 'circleci' } }
      end

      describe "when called from generate_key" do

        Then { assert_raises( error ) {
          subject.generate_keys } }
      end
    end
  end
end
