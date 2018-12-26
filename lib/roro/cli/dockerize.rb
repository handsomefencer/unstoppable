module Roro

  class CLI < Thor

    desc "dockerize", "Generates files necessary to dockerize your existing Rails project, along with a set of files for continuous deployment using CircleCI and deployment ussing sshkit."

    def dockerize
      configurate
      copy_base_files
      append_to_existing_files
    end

    desc "greenfield", "Generates files necessary to greenfield a new app within a dockerized rails container, along with a set of files necessary for continuous deployment using CircleCI"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"

    def greenfield(app=nil)
      configurate
      self.destination_root = self.destination_root + "/#{app}" unless app.nil?
      if app.nil? && !Dir.empty?('.')
        raise Roro::Error.new("Oops -- Roro can't greenfield unless the current directory is empty.")
      end
      copy_base_files
      copy_file "gitignore", ".gitignore"
      copy_file "Gemfile"
      copy_file "Gemfile.lock"
      append_to_existing_files
    end
  end
end
