require_relative 'rollon/stories'

module Roro

  class CLI < Thor

    desc "rollon", "Generates files and makes changes to your rails app 
      necessary to run it using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."

    def rollon
      confirm_dependencies
      confirm_dependency({
        system_query: "ls -A",
        warning: "This is an empty directory. You can generate a new and fully 
          dockerized Rails app using the 'greenfield' command here here but if 
          you want to containerize an existing app -- which is what the 'rollon'
          command is for -- you'll need to navigate to a directory with an app we
          can roll onto.",
        suggestion: "$ roro greenfield",
        conditional: "!Dir.glob('*').empty?" })
      @env_hash || get_configuration_variables
      # case ask("Configure using the Quickstart, Curated, or HandsomeFencer way?\n\n(1) Quikstart\n\n(2) Curated\n\n(3) HandsomeFencer\n\n", { default: '2', limited_to: %w(1 2 3) })
      # when '1'
      #   rollon_as_quickstart
      # when '2'
      #   rollon_as_dockerized
      # when '3'
      # end
      # rollon_as_dockerize
    end
    
    no_commands do
    
    end
  end
end