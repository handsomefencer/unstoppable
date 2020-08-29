require 'roro/cli/rollon/stories'
require 'roro/cli/rollon/rails/database'

module Roro

  class CLI < Thor
        
    desc "rollon::rails", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
    map "rollon::rails" => "rollon_rails"
    
    def rollon_rails(*args) 
      confirm_directory_not_empty
      confirm_dependencies
      configure_for_rollon
      copy_rails_files
      generate_config
      startup_commands
    end
    
    no_commands do
     
      def copy_rails_files
        template 'rails/.circleci/config.yml.tt', './.circleci/config.yml' 
        configure_database  
        template 'rails/docker-compose.yml.tt', './docker-compose.yml', @config.app
        template 'base/dotenv', './.env', @config.app
        directory 'rails/roro', './roro', @config.app
        take_thor_actions
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
    end
  end
end