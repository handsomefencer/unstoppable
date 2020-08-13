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
      ensure_empty_directory 
      get_configuration_variables
      copy_greenfield_files
      copy_greenfield_to_host
      @env_hash[:use_force] = { force: true }
      rollon
    end
    
    no_commands do
    
      def ensure_empty_directory 
        confirm_dependency({
          system_query: "ls -A",
          warning: "this is not an empty directory. Roro will not greenfield a new Rails app unless either a) the current directory is empty or b) you run greenfield with the --force flag",
          suggestion: "$ roro greenfield --force",
          conditional: "Dir.glob('*').empty?" })
      end
      
      def copy_greenfield_files
        template 'greenfield/Dockerfile.tt', 'Dockerfile', @env_hash
      end
      
      def copy_greenfield_to_host 
        system "DOCKER_BUILDKIT=1 docker build --file Dockerfile --output . ."
      end
    end
  end
end
