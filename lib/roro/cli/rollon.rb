require_relative 'rollon/stories'

module Roro

  class CLI < Thor

    desc "rollon", "Generates files and makes changes to your rails app 
      necessary to run it using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."

    def rollon
      confirm_directory_not_empty
      confirm_dependencies
      get_configuration_variables
      # case ask("Configure using the Quickstart, Curated, or HandsomeFencer way?\n\n(1) Quikstart\n\n(2) Curated\n\n(3) HandsomeFencer\n\n", { default: '2', limited_to: %w(1 2 3) })
      # when '1'
      #   rollon_as_quickstart
      # when '2'
        # rollon_as_dockerize
      # when '3'
      # end
      rollon_as_roro
      startup_commands
    end
    
    no_commands do
      
      def confirm_directory_not_empty 
        confirm_dependency({
          system_query: "ls -A",
          warning: "This is an empty directory. You can generate a new and fully 
            dockerized Rails app using the 'greenfield' command here here but if 
            you want to containerize an existing app -- which is what the 'rollon'
            command is for -- you'll need to navigate to a directory with an app we
            can roll onto.",
          suggestion: "$ roro greenfield",
          conditional: "!Dir.glob('*').empty?" })
      end
      
      def startup_commands 
        system 'docker-compose build'
        system 'docker-compose run web bundle'
        system 'docker-compose run web bin/rails webpacker:install'
        system 'docker-compose run web bin/rails yarn:install'
        system 'docker-compose run web bin/rails db:setup'
        system 'docker-compose up'
      end
    end
  end
end