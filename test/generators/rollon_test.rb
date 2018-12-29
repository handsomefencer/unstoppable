require "test_helper"
require "fileutils"
describe Roro::CLI do

  # before do
  #   class Foo < StringIO
  #     def puts s
  #       super unless s.start_with?('[WARNING] Attempted to create command')
  #     end
  #   end
  #   $stdout = Foo.new
  # end
  #
  # after do
  #   $stdout = STDOUT
  # end

  Given(:subject) { Roro::CLI.new }

  Given!(:prepare) {

    prepare_destination
    FileUtils.cp_r "../dummy/.", "dummy"
    Dir.chdir 'dummy' }

  Given(:env_vars) { %w(
    APP_NAME=sooperdooper
    DEPLOY_TAG=\${CIRCLE_SHA1:0:7}
    DOCKERHUB_ORG=your-docker-hub-org-name
    DOCKERHUB_PASS=your-docker-hub-password
    DOCKERHUB_USER=your-docker-hub-user-name
    SERVER_HOST=ip-address-of-your-server
    SERVER_PORT=22
    SERVER_USER=root ) }


  describe "must create" do

    Given { prepare }
    Given { subject.rollon }

    Then {

      assert_file 'Gemfile', /gem \'pg\'/
      assert_file 'Gemfile', /gem \'sshkit\'/
      assert_file '.gitignore', /docker\/\*\*\/\*.key/
      assert_file '.gitignore', /docker\/\*\*\/\*.env/

      assert_file '.circleci'
      assert_file '.circleci/config.yml'
      assert_file '.circleci/config.yml.workflow-example'
      assert_file '.circleci/Rakefile'

      assert_file 'config'
      assert_file 'config/database.yml', /ENV.fetch\('POSTGRES_DB/

      assert_file 'docker'

      assert_file 'docker/containers'

      assert_file 'docker/containers/app'
      assert_file 'docker/containers/app/development.env',
        /RAILS_ENV=development/
      assert_file 'docker/containers/app/production.env',
        /RAILS_ENV=production/
      assert_file 'docker/containers/app/Dockerfile',
        /your-docker-hub-email/

      assert_file 'docker/containers/database'
      assert_file 'docker/containers/database/development.env',
        /POSTGRES_PASSWORD=your-postgres-password/
      assert_file 'docker/containers/database/production.env',
        /POSTGRES_PASSWORD=your-postgres-password/

      assert_file 'docker/containers/web'
      assert_file 'docker/containers/web/app.conf'
      assert_file 'docker/containers/web/production.env',
        /CA_SSL=true/
      assert_file 'docker/containers/web/Dockerfile',
        /tmp\/sooperdooper.nginx/

      assert_file 'docker/env_files'
      env_vars.each { |env_var|
        assert_file 'docker/env_files/circleci.env', /export #{env_var}/ }

      assert_file 'docker/keys'

      assert_file 'docker/overrides'
      assert_file 'docker/overrides/circleci.yml'
      assert_file 'docker/overrides/production.yml' }
  end
end
