module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_dockerized
        copy_dockerignore
        if ask('Configure $stdout.sync for docker?', choices).eql?('y')
          config_std_out_true
        end
        copy_config_database_yml 
        insert_pg_gem_into_gemfile
        copy_file 'dockerize/docker-compose.yml', 'docker-compose.yml'
        template "dockerize/Dockerfile", 'Dockerfile', @env_hash
        

        copy_file 'dockerize/docker-entrypoint.sh', 'docker-entrypoint.sh'
        directory 'dockerize/.env', '.env'
        system 'docker-compose build'
        system 'docker-compose run --no-deps web bin/rails webpacker:install'
        system 'docker-compose up'
        copy_host_example
      end
    end
  end
end