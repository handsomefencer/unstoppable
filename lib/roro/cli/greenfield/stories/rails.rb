module Roro

  class CLI < Thor
    
    desc "greenfield::rails", "Greenfield a new, dockerized rails app with
    either MySQL or PostgreSQL in a separate container."
  
    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"

    map "greenfield::rails" => "greenfield_rails"
    
    def greenfield_rails(*args) 
      confirm_directory_empty
      configure_for_rollon
      copy_greenfield_files
      run_greenfield_commands
      rollon_rails(*args)
    end
        
    no_commands do
    
      def copy_greenfield_files
        @config.app['force'] = true
        directory 'rails/roro', 'roro', @config.app
        template  'rails/Dockerfile.greenfield.tt', 
        'roro/containers/app/Dockerfile', @config.app
      end
      
      def run_greenfield_commands
        system "DOCKER_BUILDKIT=1 docker build --file roro/containers/app/Dockerfile --output . ."
      end      
    end
  end
end
