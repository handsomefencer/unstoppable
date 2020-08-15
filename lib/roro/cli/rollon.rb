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
      configure_for_rollon
      copy_roro_files
    end
    
    no_commands do
     
      def configure_for_rollon
        case 
        when File.exist?('.roro_config.yml')
          @config = Roro::Configuration.new 
          @config.set_from_config# puts 'no roro config file' 
          YAML.load_file(Dir.pwd + '/.roro_config.yml') || false

        when @config.nil? 
          @config = Roro::Configuration.new 
          @config.set_from_defaults
        end
        @config
      end
      
      def yaml_from_template(file)
        content = File.read(File.dirname(__FILE__) + "/templates/#{file}")
      end
      
      def copy_roro_files 
        directory 'roro/', './', @config.app
        template 'base/Dockerfile.tt', 'roro/containers/app/Dockerfile', @config.app
        copy_file 'base/.dockerignore', '.dockerignore'
        # config_std_out_true
        configure_database  
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