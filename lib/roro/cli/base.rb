require 'byebug'
module Roro

  class CLI < Thor
    
    no_commands do

      def get_configuration_variables
        options["interactive"] ? set_interactively : set_from_defaults
        @env_hash['DEPLOY_TAG'] = "${CIRCLE_SHA1:0:7}"
        @env_hash['SERVER_PORT'] = "22"
        @env_hash['SERVER_USER'] = "root"
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
        @env_hash.map do |key, prompt|
          answer = ask("Please provide #{prompt.keys.first} or hit enter to accept: \[ #{prompt.values.first} \]")
          @env_hash[key] = (answer == "") ? prompt.values.first : answer
        end  
      end  

      def own_if_required
        system 'sudo chown -R $USER .'
      end  
      
      def copy_docker_compose 
        copy_file "base/docker-compose.yml"
      end
      
      def config_std_out_true
        prepend_to_file('config/boot.rb', "$stdout.sync = true\n\n")
      end 
      
      def gitignore_sensitive_files
        append_to_file ".gitignore", "\nroro/**/*.env\nroro/**/*.key"
      end
      
      def copy_circleci 
        directory 'base/circleci', '.circleci'
      end
      
      def copy_roro 
        directory 'base/roro', 'roro', force: true
      end
  
      def insert_roro_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'roro'\n\n", before: "group :development, :test do"
      end

      def insert_hfci_gem_into_gemfile
        insert_into_file 'Gemfile', "\n\tgem 'handsome_fencer-test'", after: "group :development, :test do"
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
        "APP_NAME" => {
          "the name of your app" => `pwd`.split('/').last.strip! },
        "RUBY_VERSION" => {
          "the version of ruby you'd like" => `ruby -v`.scan(/\d.\d/).first },
        "SERVER_HOST" => {
          "the ip address of your server" => "ip-address-of-your-server"},
        "DOCKERHUB_EMAIL" => {
          "your Docker Hub email" => "your-docker-hub-email"},
        "DOCKERHUB_USER" => {
          "your Docker Hub username" => "your-docker-hub-user-name" },
        "DOCKERHUB_ORG" => {
          "your Docker Hub organization name" => "your-docker-hub-org-name"},
        "DOCKERHUB_PASS" => {
          "your Docker Hub password" => "your-docker-hub-password"},
        "POSTGRES_USER" => {
          "your Postgres username" => "postgres"},
        "POSTGRES_PASSWORD" => {
          "your Postgres password" => "your-postgres-password"} }
    end
  end
end
