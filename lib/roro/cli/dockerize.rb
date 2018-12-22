require 'byebug'

module Roro

  class CLI < Thor
    include Thor::Actions

    desc "configurate", "set environment variables for usage later"

    def configurate

      default_values = {
        "APP_NAME" => "greenfield",
        "SERVER_HOST" => "ip-address-of-your-server",
        "DOCKERHUB_EMAIL" => "your-docker-hub-emaill",
        "DOCKERHUB_USER" => "your-docker-hub-user-name",
        "DOCKERHUB_ORG" => "your-docker-hub-org-name",
        "DOCKERHUB_PASS" => "your-docker-hub-password",
        "POSTGRES_USER" => "your-postgres-username",
        "POSTGRES_PASSWORD" => "your-postgres-password" }

      prompts = {
        "APP_NAME" => "the name of your app",
        "SERVER_HOST" => "the ip address of your server",
        "DOCKERHUB_EMAIL" => "your Docker Hub email",
        "DOCKERHUB_USER" => "your Docker Hub username",
        "DOCKERHUB_ORG" => "your Docker Hub organization name",
        "DOCKERHUB_PASS" => "your Docker Hub password",
        "POSTGRES_USER" => "your Postgres username",
        "POSTGRES_PASSWORD" => "your Postgres password" }

      prompts.map do |key, prompt|
        prompts[key] = ask("Please provide #{prompt}:")
        if prompts[key].size == 0
          prompts[key] = default_values[key]
        end
      end
      prompts
    end

    desc "dockerize", "Generates files necessary to dockerize your existing Rails project, along with a set of files for continuous deployment using CircleCI and deployment ussing sshkit."

    def dockerize
    end

    desc "greenfield", "Generates files necessary to greenfield a new app within a dockerized rails container, along with a set of files necessary for continuous deployment using CircleCI"

    def greenfield
      prompts = configurate
      directory "circleci", "./.circleci"
      directory "docker/containers/database"
      directory "docker/env_files"
      directory "docker/keys"
      directory "lib", "lib", recursive: true
      copy_file "docker-compose.yml"
      copy_file "Gemfile"
      copy_file "Gemfile.lock"
      copy_file "config/database.yml"
      copy_file "gitignore", ".gitignore"
      append_to_file ".gitignore", "\ndocker/**/*.env"
      append_to_file ".gitignore", "\ndocker/**/*.key"


      # account_type = ask("Will you be pushing images to Docker Hub under your user name or under your organization name instead?", :limited_to => ["org", "user", "skip"])
      # case account_type
      #
      # when "o"
      #   prompts['DOCKERHUB_ORG_NAME']= ask("Organization name:")
      # when "u"
      #   prompts['DOCKERHUB_ORG_NAME']= "${DOCKERHUB_USER}"
      # when "s"
      #   prompts['DOCKERHUB_ORG_NAME']= "${DOCKERHUB_USER}"
      # end
      prompts.map do |key, value|
        append_to_file 'docker/env_files/circleci.env', "\nexport #{key}=#{value}"
      end

      %w[development circleci staging production].each do |environment|
        base = "docker/containers/"

        app_env = create_file "#{base}app/#{environment}.env"
        append_to_file app_env, "DATABASE_HOST=database\n"
        append_to_file app_env, "RAILS_ENV=#{environment}\n"

        database_env = create_file "#{base}database/#{environment}.env"
        append_to_file database_env, "POSTGRES_USER=postgres\n"
        append_to_file database_env, "POSTGRES_DB=#{prompts['APP_NAME']}_#{environment}\n"
        append_to_file database_env, "POSTGRES_PASSWORD=#{prompts['POSTGRES_PASSWORD']}\n"

        ssl = (environment == "production") ? true : false
        web_env = create_file "#{base}web/#{environment}.env"
        append_to_file web_env, "CA_SSL=postgres#{ssl}\n"
      end
      %w[circleci production].each do |environment|
        template "docker/overrides/#{environment}.yml.tt", "docker/overrides/#{environment}.yml", force: true
      end

      %w[app web].each do |container|
        options = {
          email: prompts['DOCKERHUB_EMAIL'],
          app_name: prompts['APP_NAME'] }

        template("docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options)
      end
      template("docker/containers/web/app.conf.tt", "docker/containers/web/app.conf")
    end
  end
end
