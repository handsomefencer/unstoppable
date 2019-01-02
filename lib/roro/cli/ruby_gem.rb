require 'os'
module Roro

  class CLI < Thor

    include Thor::Actions

    desc "ruby_gem", "Prepare rubygem for CircleCI"

    argument :ruby_versions
    # method_option :env_vars, type: :array, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    # method_option :interactive, desc: "Set up your environment variables as you go."
    # method_option :force, desc: "force over-write of existing files"

    def ruby_gem
      byebug
      ruby_versions = ["2.5.3", "2.5.1"]
      copy_file 'ruby_gem/config.yml', '.circleci/config.yml'
      copy_file 'ruby_gem/setup-gem-credentials.sh', '.circleci/setup-gem-credentials.sh'
      directory 'ruby_gem/docker', 'docker'
      %w[app web].each do |container|
        options = {
          email: @env_hash['DOCKERHUB_EMAIL'],
          app_name: @env_hash['APP_NAME'] }

        template("docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options)
      end
    end
  end
end
