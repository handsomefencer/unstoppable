require 'roro/cli/rollon/stories'
require 'roro/cli/rollon/rails/database'

module Roro

  class CLI < Thor
        
    desc "rollon::rails::kubernetes", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
    map "rollon::rails::kubernetes" => "rollon_rails_kubernetes"
    
    def rollon_rails_kubernetes(*args) 
      configure_for_rollon
      copy_rails_files
      copy_kubernetes_files
      # generate_config
      startup_commands
    end
    
    no_commands do
     
      def copy_kubernetes_files
        template 'rails/.circleci/config.yml.tt', './.circleci/config.yml' 
        template 'rails/docker-compose.yml.tt', './docker-compose.yml', @config.app
        template 'base/dotenv', './.env', @config.app
        directory 'rails/roro', './roro', @config.app
        template 'rails/kube.rake.tt', './lib/tasks/kube.rake', @config.app
      end

      def startup_commands
        remove_roro_artifacts
        success_msg = "'\n\n#{'*' * 5 }\n\nYour Rails app is available at http://localhost:3000/'\n\n#{'*' * 5 }"
        # system 'docker-compose build'
        # system 'docker-compose run app bin/rails db:create'
        # system 'docker-compose run app bin/rails db:migrate'
        # system "docker-compose run app echo #{success_msg}"
      end
    end
  end
end