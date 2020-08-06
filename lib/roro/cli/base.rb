module Roro

  class CLI < Thor
    
    no_commands do

      def get_configuration_variables
        options["interactive"] ? set_interactively : set_from_defaults
        @env_hash[:deploy_tag] = "${CIRCLE_SHA1:0:7}"
        @env_hash[:server_port] = "22"
        @env_hash[:server_user] = "root"
        @env_hash
      end

      def set_from_defaults
        @env_hash = configuration_hash
        @env_hash.map do  |key, hash| 
          @env_hash[key] = hash.values.last 
        end
        @env_hash
      end
      
      def choices 
        { default: 'y', limited_to: ["y", "n"] }
      end
      
      def set_interactively
        @env_hash = configuration_hash
        @env_hash.map do |key, prompt|
          answer = ask("Please provide #{prompt.keys.first} or hit enter to accept: \[ #{prompt.values.first} \]")
          @env_hash[key] = (answer == "") ? prompt.values.first : answer
        end  
      end  

      def own_if_required
        system 'sudo chown -R $USER .'
      end  
      
      def copy_docker_compose 
        template "base/docker-compose.yml", 'docker-compose.yml', @env_hash
      end
      
      def config_std_out_true
        prepend_to_file('config/boot.rb', "$stdout.sync = true\n\n")
      end 
      
      def gitignore_sensitive_files
        append_to_file ".gitignore", "\nroro/**/*.env\nroro/**/*.key"
      end
      
      def copy_circleci 
        directory 'base/circleci', '.circleci', @env_hash
      end
      
      def copy_roro 
        
        directory 'base/roro/containers/app', "roro/containers/#{@env_hash[:app_name]}", @env_hash
        directory 'base/roro/containers/database', "roro/containers/#{@env_hash[:database_container]}", @env_hash
        directory 'base/roro/containers/frontend', "roro/containers/#{@env_hash[:frontend_container]}", @env_hash
      end
  
      def insert_roro_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'roro'", before: "group :development, :test do"
      end

      def insert_pg_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'pg'", before: "group :development, :test do"
      end

      def insert_hfci_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'handsome_fencer-test'", after: "group :development, :test do"
      end
      
      def copy_config_database_yml 
        copy_file "base/config/database.yml", 'config/database.yml', force: true
      end

      def copy_base_files
        copy_circleci
        copy_roro 
        copy_docker_compose 
        copy_config_database_yml
      end
    end

    private

    def configuration_hash
      {
        app_name: {
          "the name of your app" => `pwd`.split('/').last.strip! },
        ruby_version: {
          "the version of ruby you'd like" => `ruby -v`.scan(/\d.\d/).first },
        server_host: {
          "the ip address of your server" => "ip-address-of-your-server"},
        database_container: {
          "the name of your database container" => "database"},
        frontend_container: {
          "the name of your frontend container" => "frontend"},
        server_container: {
          "the name of your server container" => "nginx"},
        dockerhub_email: {
          "your Docker Hub email" => "your-docker-hub-email"},
        dockerhub_user: {
          "your Docker Hub username" => "your-docker-hub-user-name" },
        dockerhub_org: {
          "your Docker Hub organization name" => "your-docker-hub-org-name"},
        dockerhub_password: {
          "your Docker Hub password" => "your-docker-hub-password"},
        postgres_user: {
          "your Postgres username" => "postgres"},
        postgres_password: {
          "your Postgres password" => "your-postgres-password"} }
    end
  end
end
