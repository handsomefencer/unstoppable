require 'os'
module Roro

  class CLI < Thor

    include Thor::Actions

    desc "greenfield", "Greenfield a brand new rails app using Docker's instructions"

    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"

    def greenfield

      confirm_dependencies

      if !Dir['./*'].empty? && options["force"].nil?
        raise Roro::Error.new("Oops -- Roro can't greenfield a new Rails app for you unless the current directory is empty.")
      end
      copy_greenfield_files
      system 'sudo docker-compose run web rails new . --force --database=postgresql --skip-bundle'
      confirm_dependency("system 'uname'", "It looks like you're running Docker on some flavor of Linux, in which case the files created by your containers are owned by the root user of the container, and not by the user of the host machine. Please change their ownership by supplying your password below:", nil, "system 'sudo chown -R $USER .'")

      system 'sudo docker-compose build'
      system 'mv -f config/database.yml.example config/database.yml'
      system 'sudo docker-compose up --build --force-recreate -d '
      system 'sudo docker-compose run web bin/rails db:create'
    end

    no_commands do

      def confirm_dependency(system_query, warning, suggestion, action=nil)
        delineator = "\n\n" + ("-" * 80)
        warning = "#{delineator}\n\n#{warning}"
        msg = "#{warning}. The following returns false: \n\n\t$ #{system_query}\n\nPlease try these instructions: \n\n\t#{suggestion}#{delineator}"
        case

        when action
          puts warning
          puts "\n\n"
          eval(action)
        when !eval(system_query)
          raise(Roro::Error.new(msg))
        end
      end

      def confirm_dependencies
        dependencies = [
          {
            conditional: "system 'which docker'",
            warning: "It looks like Docker isn't installed",
            suggestion: "https://docs.docker.com/install/"
          }, {
            conditional: "system 'which docker-compose'",
            warning: "It looks like Docker Compose isn't installed",
            suggestion: "https://docs.docker.com/compose/install/"

          }, {
            conditional: "system 'docker ps'",
            warning: "It looks like the Docker daemon isn't running",
            suggestion: "https://docs.docker.com/config/daemon/#start-the-daemon-manually"
          }
        ]

        dependencies.each do |dependency|
          confirm_dependency(dependency[:conditional], dependency[:warning], dependency[:suggestion])
        end
      end
    end
  end
end
