module Roro

  class CLI < Thor

    no_commands do

      def set_interactively
        set_from_defaults
        set_from_env_vars
        @env_hash.map do |key, prompt|
          answer = ask("Please provide #{prompt.keys.first}:")
          @env_hash[key] = (answer == "") ? prompt.values.first : answer
        end
      end

      def set_from_env_vars
        @env_hash.map { |key, hash| @env_hash[key] = hash.values.last }
        options["env_vars"].map { |key, value| @env_hash[key] = value }
      end

      def set_from_defaults
        @env_hash.map { |key, hash| @env_hash[key] = hash.values.last }
      end

      def configurate
        @env_hash = get_defaults
        case
        when options["interactive"]
          set_interactively
        when options["env_vars"]
          set_from_env_vars
        when options.empty?
          set_from_defaults
        end
        @env_hash
      end

      def copy_base_files
        directory "circleci", "./.circleci"
        directory "docker/containers/database"
        directory "docker/env_files"
        directory "docker/keys"
        directory "lib", "lib", recursive: true
        copy_file "docker-compose.yml"
        copy_file "config/database.yml"
        %w[development circleci staging production].each do |environment|
          base = "docker/containers/"

          app_env = create_file "#{base}app/#{environment}.env"
          append_to_file app_env, "DATABASE_HOST=database\n"
          append_to_file app_env, "RAILS_ENV=#{environment}\n"

          database_env = create_file "#{base}database/#{environment}.env"
          append_to_file database_env, "POSTGRES_USER=postgres\n"
          append_to_file database_env, "POSTGRES_DB=#{@env_hash['APP_NAME']}_#{environment}\n"
          append_to_file database_env, "POSTGRES_PASSWORD=#{@env_hash['POSTGRES_PASSWORD']}\n"

          ssl = (environment == "production") ? true : false
          web_env = create_file "#{base}web/#{environment}.env"
          append_to_file web_env, "CA_SSL=#{ssl}\n"
        end

        %w[circleci production].each do |environment|
          template "docker/overrides/#{environment}.yml.tt", "docker/overrides/#{environment}.yml", force: true
        end

        %w[app web].each do |container|
          options = {
            email: @env_hash['DOCKERHUB_EMAIL'],
            app_name: @env_hash['APP_NAME'] }

          template("docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options)
        end

        @env_hash.map do |key, value|
          append_to_file 'docker/env_files/circleci.env', "\nexport #{key}=#{value}"
        end

      end

      def append_to_existing_files
        append_to_file ".gitignore", "\ndocker/**/*.env"
        append_to_file ".gitignore", "\ndocker/**/*.key"
      end
    end

    private

    def get_defaults
      {
        "APP_NAME" => {
          "the name of your app" => "sooperdooper" },
        "SERVER_HOST" => {
          "the ip address of your server" => "ip-address-of-your-server"
          },
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
