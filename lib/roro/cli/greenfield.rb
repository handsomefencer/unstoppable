module Roro

  class CLI < Thor
    
    desc "greenfield", "Greenfield a new, dockerized rails app with
    either MySQL or PostgreSQL in a separate container."
  
    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :okonomi, desc: "Let me decide everything I can."
    method_option :omakase, desc: "Leave it up to Roro but let me decide what to call some things."
    method_option :fatsufodo, desc: "Leave it up to Roro and don't ask me questions."
    method_option :force, desc: "force over-write of existing files"

    map "greenfield" => "greenfield"

    def greenfield(*args)
      configure_for_rollon(options.merge({
        greenfield: :rails,
        story: :rails
        }))
      
      @config.structure[:greenfield_actions].each {|a| eval a }
      @config.structure[:greenfield_commands].each {|a| eval a }
      
      rollon_rails
    end
        
    no_commands do
    
      def copy_greenfield_files
        @config.env['force'] = true
        src = 'rails/Dockerfile.greenfield.tt'
        dest = 'roro/containers/app/Dockerfile'
        template src, dest, @config.env
      end
      
      def run_greenfield_commands
        system "DOCKER_BUILDKIT=1 docker build --file roro/containers/app/Dockerfile --output . ."
      end      
    end
  end
end
