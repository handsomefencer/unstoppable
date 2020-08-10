require 'os'

module Roro

  class CLI < Thor

    include Thor::Actions

    desc "greenfield", "Greenfield a brand new rails app using Docker's instructions"

    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"
    
    
    def greenfield
      get_configuration_variables
      template 'greenfield/Dockerfile.tt', 'Dockerfile', @env_hash
      template 'greenfield/docker-compose.yml', 'docker-compose.yml'
      copy_file 'greenfield/Gemfile', 'Gemfile'
      copy_file 'greenfield/Gemfile.lock', 'Gemfile.lock'
      copy_file 'greenfield/docker-entrypoint.sh', 'docker-entrypoint.sh'
      directory 'dockerize/.env', '.env'
      system "docker-compose build"
      system "docker-compose run --no-deps web rails new . --skip-bundler --skip-webpack-install"
      chown_if_required
      
      rollon_as_dockerized
      # --skip-bundle
      # as_system "docker-compose build web"
      # byebug
      
      # --skip-webpack-install
      # --skip-test
      # chown_if_required
      # rollon_as_dockerized
      # chown_if_required
      # as_system "docker-compose run --no-deps web yarn"

      # as_system "docker-compose build"
      # confirm_dependencies
      # copy_greenfield_files
      # as_system("docker-compose build web")
      # as_system("docker-compose run web sh")
      # as_system('docker-compose run web gem install rails --no-document')
      # system "docker-compose run web rails new #{@env_hash[:app_name]} . --force --no-deps --skip-bundle --skip-webpack-install"
      # as_system()ls
      
      # rollon_as_dockerized
      # byebug
      # as_system('sudo roro rollon')
      # as_system('mv -f config/database.yml.example config/database.yml')
      # as_system('docker-compose up --build --force-recreate -d ')
      # as_system 'docker-compose run web bin/rails db:create'
    end
    
    no_commands do
      
      def copy_greenfield_files
        template 'greenfield/Dockerfile.tt', 'Dockerfile', @env_hash
        template 'greenfield/docker-compose.yml', 'docker-compose.yml'
        copy_file 'greenfield/Gemfile', 'Gemfile'
        copy_file 'greenfield/Gemfile.lock', 'Gemfile.lock'
      end

      def as_system(command)
        command = OS.linux? ? "sudo #{command}" : command
        system command
      end

      def chown_if_required()
        warning = "It looks like you're running Docker on some flavor of Linux, in which case the files created by your containers are owned by the root user of the container, and not by the user of the host machine. Please change their ownership by supplying your password at the prompt.",
        action = "system 'sudo chown -R $USER .'"
        msg = []
        msg << ""
        msg << delineator
        msg << warning
        msg << ""
        msg.join("\n\n")
        puts msg
        eval(action)
      end

      def delineator
        ("-" * 80)
      end

      def confirm_dependency(options)
        msg = []
        msg << ""
        msg << delineator
        msg << "It looks like #{options[:warning]}. The following bash command returns false:"
        msg << "\t$ #{options[:system_query]}"
        msg << "Please try these instructions:"
        msg << ("\t" + options[:suggestion])
        msg << delineator
        conditional = options[:conditional] ? eval(options[:conditional]) : system(options[:system_query])
        if conditional == false
          raise(Roro::Error.new(msg.join("\n\n")))
        end
      end

      def confirm_dependencies
        dependencies = [
          {
            system_query: "ls -A",
            warning: "this is not an empty directory. Roro will not greenfield a new Rails app unless either a) the current directory is empty or b) you run greenfield with the --force flag",
            suggestion: "$ roro greenfield --force",
            conditional: "Dir.glob('*').empty?"
          }, {

            system_query: "which docker",
            warning: "Docker isn't installed",
            suggestion: "https://docs.docker.com/install/"
          }, {
            system_query: "which docker-compose",
            warning: "Docker Compose isn't installed",
            suggestion: "https://docs.docker.com/compose/install/"

          }, {
            system_query: "docker info",
            warning: "the Docker daemon isn't running",
            suggestion: "https://docs.docker.com/config/daemon/#start-the-daemon-manually"
          }
        ]

        dependencies.each do |dependency|
          confirm_dependency(dependency)
        end
      end
    end
  end
end
