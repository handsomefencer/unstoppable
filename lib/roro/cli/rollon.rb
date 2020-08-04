module Roro

  class CLI < Thor

    desc "rollon", "Generates files necessary to greenfield a new app within a dockerized rails container, along with a set of files necessary for continuous deployment using CircleCI"
    method_option :interactive, desc: "Set up your environment variables as you go."

    def rollon
      get_configuration_variables
      if Dir['./*'].empty?
        raise Roro::Error.new("Oops -- Roro can't roll itself onto a Rails app if it doesn't exist. Please either change into a directory with a Rails app or generate a new one using '$ roro greenfield'.")
      end
      copy_base_files
      append_to_existing_files
      insert_into_file 'Gemfile', "gem 'sshkit'\n\n", before: "group :development, :test do"
      insert_into_file 'Gemfile', "\n\tgem 'handsome_fencer-test'", after: "group :development, :test do"
    end
  end
end
