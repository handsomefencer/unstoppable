require 'byebug'
module Roro

  class CLI < Thor

    include Thor::Actions

    desc "greenfield", "Greenfield a brand new rails app using Docker's instructions"

    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"

    def greenfield
      byebug
      if !Dir['./*'].empty? && options["force"].nil?
        raise Roro::Error.new("Oops -- Roro can't greenfield a new Rails app for you unless the current directory is empty.")
      end
      copy_greenfield_files
      system 'sleep 2s'
      system 'sudo chown -R $USER:$USER .'
      system 'sleep 2s'
      system 'docker-compose run web rails new . --force --database=postgresql --skip-bundle'
      system 'sleep 2s'
      system 'sudo chown -R $USER:$USER .'
      system 'sleep 2s'
      system 'mv -f config/database.yml.example config/database.yml'
      system 'sleep 2s'
      system 'docker-compose build'
      system 'sleep 2s'
      system 'sudo chown -R $USER:$USER .'
      system 'sleep 2s'
      system 'docker-compose up -d'
      system 'sudo chown -R $USER:$USER .'
      system 'sleep 2s'
      # system 'docker-compose run web bundle install'
      system 'docker-compose exec web bin/rails db:create'

    end
  end
end
