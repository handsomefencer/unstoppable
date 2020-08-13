require 'byebug' 
module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_roro
        # rollon_as_roro_configure
        @env_hash[:database_vendor] = 'mysql'
        rollon_as_roro_copy_files
      end

      def rollon_as_roro_configure
        choices = []
        hash = {
          'config_std_out_true' => 
            'Configure $stdout.sync for docker?',
          'gitignore_sensitive_files' => 
            'Configure .gitignore for roro?',
          'insert_roro_gem_into_gemfile' => 
            'Add RoRo to your Gemfile?',
          'insert_hfci_gem_into_gemfile' =>
            'Add handsome_fencer-test to your Gemfile?',
          "FileUtils.mv 'config/database.yml', 'config/database.yml.backup'" =>
            "Backup 'config/database.yml'?"}
        
        lines = ["Which database will you be using?"]
        databases = {
          '1' => 'PostgresQL', 
          '2' => 'MySQL' 
        } 
        databases.each do |k,v|
          lines << "(#{k}) #{v}"
        end 
        question = lines.join("\n\n")
        choice = ask(question, {default: '1', limited_to: %w(1 2) } )
        if choice.eql?(1) 
          # @env_hash[:database_vendor] = 'postgres'
        end
      end
      
      def rollon_as_roro_copy_files 
        configure_database
        directory 'roro/', './', @env_hash
        template 'base/Dockerfile.tt', 'roro/containers/app/Dockerfile', @env_hash
        copy_file 'base/.dockerignore', '.dockerignore'
        config_std_out_true
      end
      
      def configure_database 
        if @env_hash[:database_vendor].eql?('postgres')
          configure_for_pg
        elsif @env_hash[:database_vendor].eql?('mysql')
          configure_for_mysql 
        end
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