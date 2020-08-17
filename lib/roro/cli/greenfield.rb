require 'os'

module Roro

  class CLI < Thor

    include Thor::Actions

    desc "greenfield", "Greenfield a brand new rails app using Docker's instructions"
    
    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"
    
    
    def greenfield
      confirm_directory_empty
      confirm_dependencies
      configure_for_greenfielding
      copy_greenfield_files
      run_greenfield_commands
    end
    
    no_commands do
      
      def configure_for_greenfielding
        @config ||= Roro::Configuration.new(options) 
      end 
      
      def run_greenfield_commands
        remove_roro_artifacts
        system "DOCKER_BUILDKIT=1 docker build --file Dockerfile --output . ."
        rollon
      end
      
      def copy_greenfield_files
        template 'greenfield/Dockerfile.tt', 'Dockerfile', @config.app
      end      
    end
  end
end
