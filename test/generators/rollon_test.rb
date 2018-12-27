require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given do
    case
    when Dir.pwd.split('roro').last.match("/tmp/dummy")
      Dir.chdir('../')
    when Dir.pwd.split('roro').last.match("/tmp/greenfield")
      Dir.chdir('../')
    when Dir.pwd.split('/').last.match(/roro/)
      Dir.chdir('tmp')
    end
    %w(dummy greenfield).each do |directory|
      FileUtils.rm_rf(directory) if File.exist?(directory)
      FileUtils.mkdir_p(directory)
      FileUtils.copy_entry "../test/dummy", "dummy"
    end
  end

  Given { Dir.chdir 'dummy' }

  describe "must create" do

    Given { subject.rollon }

    describe "./.circleci" do

      Then {
        assert_file '.circleci'
        assert_file '.circleci/config.yml'
        assert_file '.circleci/config.yml.workflow-example'
        assert_file '.circleci/Rakefile' }
    end

    describe "Gemfile" do

      Then { assert_file 'Gemfile', /gem \'pg\'/ }
    end

    describe "./docker" do

      Then { assert_file 'docker' }

      describe "/containers" do

        Then { assert_file 'docker/containers' }

        describe "/app" do

          Then { assert_file 'docker/containers/app' }

          And {
            assert_file 'docker/containers/app/development.env',
              /RAILS_ENV=development/
            assert_file 'docker/containers/app/production.env',
              /RAILS_ENV=production/
            assert_file 'docker/containers/app/Dockerfile',
              /your-docker-hub-email/ }
        end

        describe "/database" do

          Then { assert_file 'docker/containers/database' }

          And {
            assert_file 'docker/containers/database/development.env',
              /POSTGRES_PASSWORD=your-postgres-password/
            assert_file 'docker/containers/database/production.env',
              /POSTGRES_PASSWORD=your-postgres-password/ }
        end

        describe "/web" do

          Then { assert_file 'docker/containers/web' }

          And {
            assert_file 'docker/containers/web/production.env',
              /CA_SSL=true/
            assert_file 'docker/containers/web/Dockerfile',
              /tmp\/sooperdooper.nginx/ }
        end
      end

      describe "/env_files" do

        Given(:env_vars) { %w(
          APP_NAME=sooperdooper
          DEPLOY_TAG=\${CIRCLE_SHA1:0:7}
          DOCKERHUB_ORG=your-docker-hub-org-name
          DOCKERHUB_PASS=your-docker-hub-password
          DOCKERHUB_USER=your-docker-hub-user-name
          SERVER_HOST=ip-address-of-your-server
          SERVER_PORT=22
          SERVER_USER=root ) }

        Then { assert_file 'docker/env_files' }

        And {
          env_vars.each { |env_var| assert_file 'docker/env_files/circleci.env', /export #{env_var}/ } }
      end

      describe "/keys" do

        Then { assert_file 'docker/keys' }
      end

      describe "/overrides" do

        Then { assert_file 'docker/overrides' }

        And {
          assert_file 'docker/overrides/circleci.yml'
          assert_file 'docker/overrides/production.yml' }
      end
    end

    describe "./config" do

      Then { assert_file 'config' }

      And { assert_file 'config/database.yml' }
    end
  end
end
