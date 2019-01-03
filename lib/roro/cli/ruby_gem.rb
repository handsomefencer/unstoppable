require 'os'
module Roro

  class CLI < Thor

    include Thor::Actions

    desc "ruby_gem", "Prepare rubygem for CircleCI"

    # argument :ruby_versions, required: false
    # method_option :env_vars, type: :array, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    # method_option :interactive, desc: "Set up your environment variables as you go."
    # method_option :force, desc: "force over-write of existing files"

    def ruby_gem(rubies = nil)

      ruby_versions = ["2.5.1", "2.5.3"]
      copy_file 'ruby_gem/docker-compose.yml', 'docker-compose.yml'
      copy_file 'ruby_gem/config.yml', '.circleci/config.yml'
      copy_file 'ruby_gem/setup-gem-credentials.sh', '.circleci/setup-gem-credentials.sh'
      directory 'ruby_gem/docker', 'docker', { ruby_version: "2.5"}
      # service_blocks = "\n"
      ruby_versions.each do |ruby|
        ruby = ruby.gsub('.', '-')
        doc_loc = "docker/containers/#{ruby}/Dockerfile"
        content = <<-EOM
  app-#{ruby}:
    build:
      context: .
      dockerfile: #{doc_loc}

        EOM
        # service_blocks = service_blocks + content
        append_to_file 'docker-compose.yml', content
        template 'ruby_gem/docker/containers/app/Dockerfile.tt', doc_loc, {ruby_version: ruby}
        # append_to_file 'docker-compose.yml', "\n  app-#{ruby}:\n    build:\n\s\s\s\s\s\scontext:"
      end
      # byebug


      # end
#       <<EOF
#    This is the first way of creating
#    here document ie. multiple line string.
# EOF
      # %w[app web].each do |container|
      #   options = {
      #     email: @env_hash['DOCKERHUB_EMAIL'],
      #     app_name: @env_hash['APP_NAME'] }
      #
      #   template("docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options)
      # end
    end
  end
end
