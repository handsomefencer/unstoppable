require_relative 'rollon/use_cases'

module Roro

  class CLI < Thor

    desc "rollon", "Generates files and makes changes to your rails app necessary
          to run it using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as you go."

    def rollon
      # if Dir['./*'].empty?
      #   raise Roro::Error.new("Oops -- Roro can't roll itself onto a Rails app if it
      #     doesn't exist. Please either change into a directory with a Rails app or 
      #     generate a new one using '$ roro greenfield'.")
      # end
      get_configuration_variables
      # case ask("Configure using the Quickstart, Curated, or HandsomeFencer way?\n\n(1) Quikstart\n\n(2) Curated\n\n(3) HandsomeFencer\n\n", { default: '2', limited_to: %w(1 2 3) })
      # when '1'
      #   rollon_as_quickstart
      # when '2'
      #   rollon_as_dockerized
      # when '3'
      # end
      rollon_as_dockerized
    end
  end
end