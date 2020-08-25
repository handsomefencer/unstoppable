require 'roro/cli/rollon/stories'

module Roro

  class CLI < Thor

    desc "rollon", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."

    def rollon
      confirm_directory_not_empty
      confirm_dependencies
      # remove_roro_artifacts 

      configure_for_rollon
      
      copy_roro_files
      generate_config
      startup_commands
    end
    
    no_commands do
     
      def configure_for_rollon
        @config ||= Roro::Configuration.new(options) 
      end
      
      def yaml_from_template(file)
        File.read(File.dirname(__FILE__) + "/templates/#{file}")
      end
      
      def copy_roro_files
        directory 'rails/.circleci', './.circleci' 
        configure_database  
        directory 'roro', './', @config.app
        template 'base/Dockerfile.tt', 'roro/containers/app/Dockerfile', @config.app
        take_thor_actions
      end
      
      def take_thor_actions 
        @config.thor_actions.each {|k, v| eval(k) if v.eql?('y') }  
      end
              
      def startup_commands
        success_msg = "'\n\n#{'*' * 5 }\n\nYour Rails app is available at http://localhost:3000/'\n\n#{'*' * 5 }"
        system 'docker-compose build'
        system 'docker-compose run web bundle'
        system 'docker-compose run web bin/rails webpacker:install'
        system 'docker-compose run web bin/rails yarn:install'
        system 'docker-compose run web bin/rails db:create'
        system 'docker-compose run web bin/rails db:migrate'
        system 'docker-compose up -d'
        system "docker-compose run web echo '\n\nYour Rails app is available at http://localhost:3000/'"
      end
      
      def confirm_directory_empty 
        confirm = confirm_dependency({
          system_query: "ls -A",
          warning: "this is not an empty directory. Roro will not greenfield a new Rails app unless either a) the current directory is empty or b) you run greenfield with the --force flag",
          suggestion: "$ roro greenfield --force",
          conditional: "Dir.glob('*').empty?" }) 
        confirm || true
      end

    
      def confirm_dependency(options)
        msg = []
        msg << ""
        msg << delineator
        msg << "It looks like #{options[:warning]}. The following bash command returns false:"
        msg << "\t$ #{options[:system_query]}"
        msg << "Please try these instructions:"
        msg << ("\t" + options[:suggestion])
        msg << delineator
        conditional = options[:conditional] ? eval(options[:conditional]) : system(options[:system_query])
        if conditional == false
          raise(Roro::Error.new(msg.join("\n\n")))
        else 
          true 
        end
      end
      
    end
  end
end