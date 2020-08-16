require_relative 'rollon/stories'

module Roro

  class CLI < Thor

    desc "rollon", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
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
        File.read(File.dirname(__FILE__) + "/templates/#{file}")
      end
      
      def copy_roro_files 
        configure_database  
        directory 'roro/', './', @config.app
        template 'base/Dockerfile.tt', 'roro/containers/app/Dockerfile', @config.app
        take_thor_actions
      end
      
      def take_thor_actions 
        @config.thor_actions.each do |key, value|
          case 
          when value.eql?('y')
            eval(key)
          end
        end
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