module Roro
  
  class CLI < Thor
    
    no_commands do
      
      def copy_dockerignore 
        copy_file 'base/.dockerignore', '.dockerignore'
      end 
      
      def copy_host_example 
        copy_file 'base/livereload/hosts.example', 'hosts.example' 
      end

      def copy_docker_compose 
        template "base/docker-compose.yml", 'docker-compose.yml', @env_hash
      end
      
      def copy_database_yml_pg 
        copy_file "base/config/database.pg.yml", 'config/database.yml', force: @env_hash[:use_force]
      end
    end
  end 
end
