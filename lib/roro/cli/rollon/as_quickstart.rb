module Roro
  class CLI < Thor

    no_commands do

      def rollon_as_quickstart
        copy_file "quickstart/docker-compose.yml", 'docker-compose.yml'
        copy_file "quickstart/entrypoint.sh", 'entrypoint.sh'
        copy_file "quickstart/database.yml", "config/database.yml"
        template "quickstart/Dockerfile", 'Dockerfile', @env_hash

        insert_pg_gem_into_gemfile
        system 'sudo chown -R $USER .'
      end
    end
  end
end