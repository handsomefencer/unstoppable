module Roro

  class CLI < Thor
        
    no_commands do
    
      def greenfield(*args)
        confirm_directory_empty
        confirm_dependencies
        # remove_roro_artifacts
        configure_for_greenfielding
        copy_greenfield_files
        run_greenfield_commands
      end
      
      def configure_for_greenfielding
        @config ||= Roro::Configuration.new(options) 
      end 
      
      def run_greenfield_commands
        system "DOCKER_BUILDKIT=1 docker build --file Dockerfile --output . ."
        rollon
      end
      
      def copy_greenfield_files
        template 'greenfield/Dockerfile.tt', 'Dockerfile', @config.app
        template 'roro/docker-compose.yml.tt', 'docker-compose.yml', @config.app
      end      
    end
  end
end
