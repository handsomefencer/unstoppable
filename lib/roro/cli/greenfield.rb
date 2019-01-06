require 'os'
require 'byebug'
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
      # copy_greenfield_files
      # system 'sudo docker-compose run web rails new . --force --database=postgresql --skip-bundle'
      # no?("If you're running Docker on Linux, the files 'rails new' created are owned by root. This happens because the container runs as the root user. If this is the case, change the ownership of the new files.")
      # system 'sudo chown -R $USER .' if OS.linux?
      # # own_if_required
      # }, {
      #   conditional: OS.linux?,
      #   warning: "It looks like you're running Docker on some flavor of Linux, in which casee the files created by your containers are owned by the root user of the container, and not by the user of the host machine. To finish , you will be asked for your password to change ownership of these newly generated files."
      # }
      # if OS.linux?
      #   puts "It looks like you're running Docker on some flavor of Linux, in which case the files created by your containers are owned by the root user of the container, and not by the user of the host machine. To change ownership of these newly generated files, please supply your password."
      #   system 'sudo chown -R $USER .'
      # end

      system 'sudo docker-compose build'
      # # own_if_required
      system 'mv -f config/database.yml.example config/database.yml'
      # # own_if_required
      system 'sudo docker-compose up --build --force-recreate -d '
      # # own_if_required
      system 'sudo docker-compose run web bin/rails db:create'

    end

    no_commands do

      def confirm_dependency(system_query, warning, suggestion, action=nil)
        delineator = "-" * 80
        warning = "\n\n#{delineator}\n\n#{warning}"
        msg = "#{warning}. The following returns false: \n\n\t$ #{system_query}\n\nPlease try these instructions: \n\n\t#{suggestion}\n\n#{delineator}"
        case

        when action.to_s.size > 0

          puts warning
          # action
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
          #
          # {
          #   condition: "which docker-compose",
          #   suggestion: "It looks like Docker Compose isn't installed -- '$ which docker-compose'. Please follow the instructions here to install it: https://docs.docker.com/compose/install/"
          # }
          #
          # {
          #   condition: "uname",
          #   suggestion: "It looks like you're running Docker on some flavor of Linux, in which casee the files created by your containers are owned by the root user of the container and not by the user of your host machine. To finish , you will be asked for your password to change ownership of these newly generated files."
          # }
        # }

        # if system 'which docker'
        #   say "It looks like Docker isn't installed -- '$ which docker'. Please follow the instructions here to install it: https://docs.docker.com/install/"
        # end

        # if system 'docker ps'
        #   say "It looks like the Docker daemon isn't running -- '$ docker ps'. Please follow the instructions here to start it: https://docs.docker.com/config/daemon/#start-the-daemon-manually"
        # end

        # if system "which docker-compose"
        #   "It looks like Docker Compose isn't installed -- '$ which docker-compose'. Please follow the instructions here to install it: https://docs.docker.com/compose/install/"
        # end
      end
    end
  end
end
