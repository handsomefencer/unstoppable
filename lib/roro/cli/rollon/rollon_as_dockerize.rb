module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_dockerize
        rollon_dockerize_files 
        system 'docker-compose build'
        system 'docker-compose run --no-deps web yarn'
        system 'docker-compose up'
      end
      
       
      
      def configure_for_pg 
        service = [
          "  database:",
          "    image: postgres",
          "    env_file:",
          "      - .env/development/database",
          "    volumes:",
          "      - db_data:var/lib/postgresql/data"
        ].join("\n")
        
        @env_hash[:database_service] = service
      end
      
      def rollon_dockerize_files 
        directory 'dockerize', '.', @env_hash
        copy_dockerignore
        if ask("Configure $stdout.sync in 'config/boot.rb' for docker?", choices).eql?('y')
          config_std_out_true
        end
        if ask('Configure your app to use Postgresql?', choices).eql?('y')
          copy_database_yml_pg
          insert_pg_gem_into_gemfile
        end
        @env_hash[:rails_env] = 'development'
        template 'base/.env/database.env.tt', '.env/development/database', @env_hash
        template 'base/.env/web.env.tt', '.env/development/web', @env_hash
      end
    end
  end
end