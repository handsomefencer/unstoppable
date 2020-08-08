module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_dockerized
        copy_file 'base/.dockerignore', '.dockerignore'
        copy_file 'dockerize/docker-compose.yml', 'docker-compose.yml'
        template "dockerize/Dockerfile", 'Dockerfile', @env_hash

        copy_file 'dockerize/docker-entrypoint.sh', 'docker-entrypoint.sh'
        directory 'dockerize/.env', '.env'
        # if ask('Configure $stdout.sync for docker?', choices).eql?('y')
        #   config_std_out_true
        # end
        # if ask('Configure .gitignore for roro?', choices).eql?('y')
        #   gitignore_sensitive_files
        # end
        # if ask('Add RoRo to your Gemfile?', choices).eql?('y')
        #   insert_roro_gem_into_gemfile
        # end
        # if ask("Backup 'config/database.yml'?").eql?('y')
        #   FileUtils.mv 'config/database.yml', "config/database.yml.backup"
        # end
        # # copy_circleci
        # # copy_roro
        # copy_docker_compose
        # copy_config_database_yml
      end
    end
  end
end