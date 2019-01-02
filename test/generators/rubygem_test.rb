require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination 'dummy_gem' }

  describe "usage" do

    Given { subject.ruby_gem }
    Then { subject.env_vars.must_equal "blah" }

    describe "must generate files" do

      Then do

        assert_file '.docker-compose.yml'

        assert_file '.circleci'
        assert_file '.circleci/config.yml'
        assert_file '.circleci/setup-gem-credentials.sh'
# byebug
        assert_file 'docker'

        assert_file 'docker/containers'

        assert_file 'docker/containers/app'
        assert_file 'docker/containers/app/Dockerfile'
      end
    end
  end
end
