module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_dockerized
        if ask('Configure $stdout.sync for docker?', choices).eql?('y')
          config_std_out_true
        end
        if ask('Configure .gitignore for roro?', choices).eql?('y')
          gitignore_sensitive_files
        end
        if ask('Add RoRo to your Gemfile?', choices).eql?('y')
          insert_roro_gem_into_gemfile
        end
        if ask("Backup 'config/database.yml'?").eql?('y')
          FileUtils.mv 'config/database.yml', "config/database.yml.backup"
        end
        copy_circleci
        copy_roro
        copy_docker_compose
        copy_config_database_yml
      end
    end
  end
end