module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_roro
        # rollon_as_roro_copy_files
      end
      
      def rollon_as_roro_copy_files 
        configure_database
        directory 'roro/', './', @env_hash
        template 'base/Dockerfile.tt', 'roro/containers/app/Dockerfile', @env_hash
        copy_file 'base/.dockerignore', '.dockerignore'
        config_std_out_true
      end
      
      
      def configure_for_pg 
        insert_pg_gem_into_gemfile
        %w(development production test staging ci).each do |environment| 
          @env_hash[:rails_env] = environment
          template(
            'base/.env/web.env.tt',
            "roro/containers/app/#{environment}.env", @env_hash
          )
          template(
            'base/.env/database.env.tt',
            "roro/containers/database/#{environment}.env", @env_hash
          )
        end
        copy_file 'base/config/database.pg.yml', 'config/database.yml', force: true
        service = [
          "  database:",
          "    image: postgres",
          "    env_file:",
          "      - roro/containers/database/development.env",
          "    volumes:",
          "      - db_data:/var/lib/postgresql/data"
        ].join("\n")
        
        @env_hash[:database_service] = service
      end
      
      def configure_for_mysql 
        insert_mysql_gem_into_gemfile
        copy_file 'base/config/database.mysql.yml', 'config/database.yml', force: true
        %w(development production test staging ci).each do |environment| 
          @env_hash[:rails_env] = environment
          template(
            'base/.env/web.env.tt',
            "roro/containers/app/#{environment}.env", @env_hash
          )
          template(
            'base/.env/database.mysql.env.tt',
            "roro/containers/database/#{environment}.env", @env_hash
          )
        end
        service = [
          "  database:",
          "    image: 'mysql:5.7'",
          "    env_file:",
          "      - roro/containers/database/development.env",
          "      - roro/containers/app/development.env",
          "    volumes:",
          "      - db_data:/var/lib/mysql",
          "    restart: always",
          "    ports:",
          "      - '3307:3306'"
        ].join("\n")
        
        @env_hash[:database_service] = service
      end
    end
  end
end